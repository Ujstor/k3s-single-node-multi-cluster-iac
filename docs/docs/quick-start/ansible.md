Ansible is not listed in requirements for a reason. We have encapsulated Ansible configuration and run it in a Docker container.

From the project root, run the following command to build the Docker image:

```bash
docker build -t ansible-k3s-single-node-multi-cluster ./iac/ansible/k3s-deploy
```
## Inventory

To achieve the minimal K3s deployment mentioned earlier, note these key configurations in the inventory file:

```yaml
server:
  children:
    k3s0:
      hosts:
        api.k3s0.ujstor.com:
          api_endpoint: api.k3s0.ujstor.com
          k3s_control_node: true
          k3s_server_init_node: true
          server_group: "k3s0"
    k3s1:
      hosts:
        api.k3s1.ujstor.com:
          api_endpoint: api.k3s1.ujstor.com
          k3s_control_node: true
          k3s_server_init_node: true
          server_group: "k3s1"
  vars:
    k3s_version: v1.31.1+k3s1
    extra_server_args: >-
      --cluster-cidr=10.255.0.0/16
      --service-cidr=10.254.0.0/16
      --disable servicelb
      --disable traefik
      --flannel-backend=none
      --egress-selector-mode=disabled
      --disable-cloud-controller
      --disable-helm-controller
      --disable-network-policy
      --disable-kube-proxy
      --tls-san {{ api_endpoint }}
```

## Run Ansible

We are mounting SSH keys (created by Terraform) and the inventory file to the container:

```bash
docker run --rm -it \
    -v $(pwd)/iac/ansible/inventory_k3s_deploy.yml:/config/inventory.yml \
    -v $(pwd)/iac/terraform/nodes-infra/.ssh/k3s_prod_hetzner_ssh_key:/secrets/ssh_key \
    -v $(pwd)/iac/terraform/nodes-infra/.ssh/k3s_prod_hetzner_ssh_key.pub:/secrets/ssh_key.pub \
    ansible-k3s-single-node-multi-cluster
```

Ansible is custom configured in ansible.cfg, which is why mounting points can be different from classic Ansible configuration.

## Kubeconfig
After the Ansible playbook finishes, you will have a kubeconfig file in the Docker container's root. These files are used to access the K3s clusters.
Save them and later, you can [back up](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/tree/master/iac/terraform/s3-kubeconfig-backup) these files in the same MinIO tenant as your Terraform state and SSH keys.

```bash
cat kubeconfig-*
```

In the next steps, we will deploy Cilium and ArgoCD on the K3s0 cluster and see real magic happen.
