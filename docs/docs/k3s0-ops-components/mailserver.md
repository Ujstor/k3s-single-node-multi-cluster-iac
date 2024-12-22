The MailServer chart deploys a [docker-mailserver](https://github.com/docker-mailserver/docker-mailserver) implementation. While the configuration can be very complex, the [official documentation](https://docker-mailserver.github.io/docker-mailserver/latest/) is very good and serves as an excellent guide for understanding and properly configuring the mailserver.


## Preconfig

### DNS Records

The node-infra directory, located within the IaC folder, contains [Cloudflare DNS records](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/blob/35d4d9d355e53343a046df22f39ccd57c85283f2/iac/terraform/nodes-infra/cloudflare_dns.tf#L53), specifically MX and A records.

```hcl
    mx = {
      zone_id  = var.cloudflare_zone_id
      name     = "@"
      content  = "mail.ujstor.com"
      type     = "MX"
      priority = 10
    }
    mail = {
      zone_id = var.cloudflare_zone_id
      name    = "mail"
      content = module.floating_ip.floating_ip_status.ip-1.ip
      type    = "A"
      ttl     = 60
      proxied = false
    }
```

### Cert Issuer

We can't use the ClusterIssuer that is already deployed because there is no ingress deployed with the mailserver (the service type is LoadBalancer).

For this reason, we need to:

 - Create an API token with read/write permissions
 - Add data to the Issuer object
 - Deploy it in the namespace where the mailserver chart will be deployed with Helm

```yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-issuer
  namespace: mailserver
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-key
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: mailserver-issuer
            key: api-key
---
apiVersion: v1
kind: Secret
metadata:
  name: mailserver-issuer
  namespace: mailserver
type: Opaque
stringData:
  api-key: <Cloudflare-api-key>
```

The chart needs to reference:

 - The mail domain in the deployment.env.OVERRIDE_HOSTNAME section
 - The issuer name in certificate.issuerRef.name section
 - Specifying the certificate name is enough, and the Certificate object will be created

```yaml
dockermailserver:
  deployment:
    env:
      OVERRIDE_HOSTNAME: mail.ujstor.com
  certificate: mailserver-tls

certificates:
  organization: Ujstor
  duration: 2160h
  renewBefore: 360h
  issuerRef:
    name: letsencrypt-issuer
    kind: Issuer
```

The Certificate object is under the templates directory and it will automatically create and mount the mailserver-tls secret to the pod.

### Network config

The service type is LoadBalancer, so we need to add an additional [floating IP](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/blob/35d4d9d355e53343a046df22f39ccd57c85283f2/iac/terraform/nodes-infra/main.tf#L43) to the server. This can be achieved with terraform-hetzner-modules that I am using for provisioning Hetzner infrastructure.

```hcl
module "floating_ip" {
  source = "github.com/Ujstor/terraform-hetzner-modules//modules/network/floating_ip?ref=v0.0.8"

  floating_ip_config = {
    ip-1 = {
      server_id       = module.k3s_prod.server_info.k3s0-ops.id
      server_location = module.k3s_prod.server_info.k3s0-ops.location
    }
  }
}
```
And once we have the IP, we need to add it to the [MetalLB IPAddressPool](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/blob/master/cluster/k3s0-ops/helm/system/metallb-config/values.yaml).

```bash
Outputs:

floating_ip_info = {
  "ip-1" = {
    "ip" = "49.13.32.42"
  }
}
server_info = {
  "k3s0-ops" = {
    "id" = "57518060"
    "ip" = "188.245.179.200"
    "location" = "nbg1"
    "status" = "running"
  }
  "k3s1-app" = {
    "id" = "57518059"
    "ip" = "49.13.159.158"
    "location" = "nbg1"
    "status" = "running"
  }
}
```

```yaml
metallb-config:
  ipAddressPool:
    addresses:
     - 188.245.179.200/32
     - 49.13.32.42/32

  l2Advertisement:
    enabled: true
```

Push to main and ArgoCD will provision MetalLB and mailserver deployment.

## MailServer configuration

Once deployed, you will have 120 seconds to create an account. I am using [k9s](https://k9scli.io/), and by pressing 's' on the pod, you will have an active shell. There are other ways to do this in a more automated way, but for now we are following these steps manually so we can better understand what is happening.

Execute the command to create an email account.

```bash
setup email add admin@ujstor.com password1234
```
This is a minimal configuration. Test it with an application that supports SMTP - for example, Uptime Kuma can send you notifications when your website endpoint is unavailable.

Forwarding email to Gmail with a minimal configuration will not work. Looking at the logs, you can see the issue: your SMTP server successfully accepts and processes the email, but it's rejected by Gmail's SMTP server. While your server accepts the message and queues it, delivery to Gmail fails.

Pod logs:

```bash
postfix/smtp[5465]: 940A663D054: to=<astipan@gmail.com>, relay=gmail-smtp-in.l.google.com[142.251.31.26]:25, delay=0.48, delays=0.08/0.02/0.05/0.33, dsn=5.7
```

The dsn=5.7 error code suggests that Gmail is rejecting the email due to authentication/security requirements.

To fix this, you should Generate DKIM key:

### DKIM keys

Create active shell in pod, and execute:

```bash
setup config dkim
2024-12-22 19:45:58+00:00 INFO  rspamd-dkim: Creating DKIM keys of type 'rsa' and length '2048' with selector 'mail' for domain 'ujstor.com'
2024-12-22 19:45:59+00:00 INFO  rspamd-dkim: Successfully created DKIM keys
2024-12-22 19:45:59+00:00 INFO  rspamd-dkim: Supplying a default configuration (to '/tmp/docker-mailserver/rspamd/override.d/dkim_signing.conf')
rspamd: stopped
rspamd: started
2024-12-22 19:45:59+00:00 INFO  rspamd-dkim: Here is the content of the TXT DNS record mail._domainkey.ujstor.com that you need to create:

v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlKuh1diP0S5sKdXtlMnjqtDijNqXAHnsHo4jRySPS8TgjwJIKuKa8jq4LlsStZoUXcCEGlqJuBnUqVUeOoBkCrJRqQqh3sg1YgPTzKIfqb6Yq10x6N//BftlgvIB7y0I/UdcE6S3i4Umub0xB6/A7pY6tXtqqlT91jDvl1gN2wugQF0unsPrqzVyplOkS8mT2Uz08gtrgf3Aa7gQ+IQo93hciLH0I/Ik9LK5Lfj62J4SfMUAAQBw5gSETi0ZIlzd9xkziBYpx6xDDjqEp8L2fbejstYlERMDIQOaKibvCwG2VF52oIMkNuu7R4qpChjsnbvFqa7hSQCfAluwjl2bfwIDAQAB

rspamd: stopped
rspamd: started
```
Then create new TXT record in Cloudflare DNS with the content provided under iac and run terrafrom apply:

```hcl
    mail-dkms = {
      zone_id = var.cloudflare_zone_id
      name    = "mail._domainkey.ujstor.com"
      content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlKuh1diP0S5sKdXtlMnjqtDijNqXAHnsHo4jRySPS8TgjwJIKuKa8jq4LlsStZoUXcCEGlqJuBnUqVUeOoBkCrJRqQqh3sg1YgPTzKIfqb6Yq10x6N//BftlgvIB7y0I/UdcE6S3i4Umub0xB6/A7pY6tXtqqlT91jDvl1gN2wugQF0unsPrqzVyplOkS8mT2Uz08gtrgf3Aa7gQ+IQo93hciLH0I/Ik9LK5Lfj62J4SfMUAAQBw5gSETi0ZIlzd9xkziBYpx6xDDjqEp8L2fbejstYlERMDIQOaKibvCwG2VF52oIMkNuu7R4qpChjsnbvFqa7hSQCfAluwjl2bfwIDAQAB"
      type    = "TXT"
      ttl     = 1
    }
```
### Test
If you now send an email to Gmail, it will be accepted and delivered.

[gmass SMTP test](https://www.gmass.co/smtp-test) logs
```bash
Connected to smtp://mail.ujstor.com:587/?starttls=when-available
<< 220 mail.ujstor.com ESMTP
>> EHLO [172.31.11.248]
<< 250-mail.ujstor.com
<< 250-PIPELINING
<< 250-SIZE 10240000
<< 250-ETRN
<< 250-STARTTLS
<< 250-ENHANCEDSTATUSCODES
<< 250-8BITMIME
<< 250-DSN
<< 250 CHUNKING
>> STARTTLS
<< 220 2.0.0 Ready to start TLS
>> EHLO [172.31.11.248]
<< 250-mail.ujstor.com
<< 250-PIPELINING
<< 250-SIZE 10240000
<< 250-ETRN
<< 250-AUTH PLAIN LOGIN
<< 250-AUTH=PLAIN LOGIN
<< 250-ENHANCEDSTATUSCODES
<< 250-8BITMIME
<< 250-DSN
<< 250 CHUNKING
>> AUTH PLAIN AGFkbWluQHVqc3Rvci5jb20AcGFzc3dvcmQxMjM0
<< 235 2.7.0 Authentication successful
>> MAIL FROM:<admin@ujstor.com> SIZE=551
>> RCPT TO:<astipan@gmail.com>
<< 250 2.1.0 Ok
<< 250 2.1.5 Ok
>> DATA
<< 354 End data with <CR><LF>.<CR><LF>
>> From: admin@ujstor.com
>> Date: Sun, 22 Dec 2024 19:56:52 퍍
>> Subject: SMTP test from mail.ujstor.com
>> Message-Id: <NDGOPQ70YOU4.5VT4A0G77RFU3@WIN-AUIR3RRGP88>
>> To: astipan@gmail.com
>> MIME-Version: 1.0
>> Content-Type: multipart/alternative; boundary="=-qL2핺迼쾍瘘=="
>>
>> --=-qL2핺迼쾍瘘==
>> Content-Type: text/plain; charset=utf-8
>>
>> Test message
>> --=-qL2핺迼쾍瘘==
>> Content-Type: text/html; charset=utf-8
>> Content-Id: <NDGOPQ70YOU4.8C46H6CU77TD@WIN-AUIR3RRGP88>
>>
>> <b>Test message</b>
>> --=-qL2핺迼쾍瘘==--
>> .
<< 250 2.0.0 Ok: queued as EF1B7645EE7
```

Pod logs
```bash
24-12-22 19:40:43+00:00 INFO  start-mailserver.sh: Welcome to docker-mailserver v14.0.0                                                                                                                                                                                                                                                                     │
│ 2024-12-22 19:40:43+00:00 INFO  start-mailserver.sh: Checking configuration                                                                                                                                                                                                                                                                               │
│ 2024-12-22 19:40:43+00:00 INFO  start-mailserver.sh: Configuring mail server                                                                                                                                                                                                                                                                              │
│ 2024-12-22 19:40:43+00:00 WARN  start-mailserver.sh: You need at least one mail account to start Dovecot (120s left for account creation before shutdown)                                                                                                                                                                                                 │
│ 2024-12-22 19:40:53+00:00 WARN  start-mailserver.sh: You need at least one mail account to start Dovecot (110s left for account creation before shutdown)                                                                                                                                                                                                 │
│ 2024-12-22 19:41:03+00:00 WARN  start-mailserver.sh: You need at least one mail account to start Dovecot (100s left for account creation before shutdown)                                                                                                                                                                                                 │
│ 2024-12-22 19:41:13+00:00 WARN  start-mailserver.sh: You need at least one mail account to start Dovecot (90s left for account creation before shutdown)                                                                                                                                                                                                  │
│ 2024-12-22 19:41:24+00:00 INFO  start-mailserver.sh: Starting daemons                                                                                                                                                                                                                                                                                     │
│ 2024-12-22 19:41:27+00:00 INFO  start-mailserver.sh: mail.ujstor.com is up and running                                                                                                                                                                                                                                                                    │
│ tail: inotify cannot be used, reverting to polling: Too many open files                                                                                                                                                                                                                                                                                   │
│ 2024-12-22T19:41:27.823323+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/postfix-script[932]: starting the Postfix mail system                                                                                                                                                                                                               │
│ 2024-12-22T19:41:27.840527+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/master[933]: daemon started -- version 3.7.10, configuration /etc/postfix                                                                                                                                                                                           │
│ 2024-12-22 19:45:59,990 WARN stopped: rspamd (terminated by SIGTERM)                                                                                                                                                                                                                                                                                      │
│ 2024-12-22T19:56:51.364820+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/submission/smtpd[4467]: connect from ec2-54-212-131-181.us-west-2.compute.amazonaws.com[54.212.131.181]                                                                                                                                                             │
│ 2024-12-22T19:56:52.324327+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/submission/smtpd[4467]: Anonymous TLS connection established from ec2-54-212-131-181.us-west-2.compute.amazonaws.com[54.212.131.181]: TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits)                                                                  │
│ 2024-12-22T19:56:52.979665+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/submission/smtpd[4467]: EF1B7645EE7: client=ec2-54-212-131-181.us-west-2.compute.amazonaws.com[54.212.131.181], sasl_method=PLAIN, sasl_username=admin@ujstor.com                                                                                                   │
│ 2024-12-22T19:56:53.355001+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/sender-cleanup/cleanup[4477]: EF1B7645EE7: message-id=<NDGOPQ70YOU4.5VT4A0G77RFU3@WIN-AUIR3RRGP88>                                                                                                                                                                  │
│ 2024-12-22T19:56:53.355079+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/sender-cleanup/cleanup[4477]: EF1B7645EE7: replace: header MIME-Version: 1.0 from ec2-54-212-131-181.us-west-2.compute.amazonaws.com[54.212.131.181]; from=<admin@ujstor.com> to=<astipan@gmail.com> proto=ESMTP helo=<[172.31.11.248]>: MIME-Version: 1.0          │
│ 2024-12-22T19:56:53.580667+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/qmgr[935]: EF1B7645EE7: from=<admin@ujstor.com>, size=585, nrcpt=1 (queue active)                                                                                                                                                                                   │
│ 2024-12-22T19:56:53.722477+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/smtp[4478]: Trusted TLS connection established to gmail-smtp-in.l.google.com[142.251.31.27]:25: TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits) key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256                              │
│ 2024-12-22T19:56:53.761942+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/submission/smtpd[4467]: disconnect from ec2-54-212-131-181.us-west-2.compute.amazonaws.com[54.212.131.181] ehlo=2 starttls=1 auth=1 mail=1 rcpt=1 data=1 commands=7                                                                                                 │
│ 2024-12-22T19:56:54.285473+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/smtp[4478]: EF1B7645EE7: to=<astipan@gmail.com>, relay=gmail-smtp-in.l.google.com[142.251.31.27]:25, delay=1.3, delays=0.62/0.03/0.14/0.54, dsn=2.0.0, status=sent (250 2.0.0 OK  1734897414 a640c23a62f3a-aac0f040f87si490882066b.477 - gsmtp)                     │
│ 2024-12-22T19:56:54.286079+00:00 mailserver-dockermailserver-7f75d8656b-78f5h postfix/qmgr[935]: EF1B7645EE7: removed 
```

## Test tools

 - The complete IP check for sending Mailservers: [https://multirbl.valli.org/](https://multirbl.valli.org/)
 - SMTP test: [https://www.gmass.co/smtp-test](https://www.gmass.co/smtp-test)
