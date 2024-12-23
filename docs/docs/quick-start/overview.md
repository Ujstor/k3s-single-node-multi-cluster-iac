First step is to create API key in the Hetzner Cloud Console and Cloudflare API key in the Cloudflare dashboard for domain management.
Import them as secrets in ./iac/terraform/nodes-infra/.auto.tfvars file:

```tfvars
hcloud_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
cloudflare_api_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
cloudflare_zone_id   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
If you use more than one domain, as in my example, do the same thing for every Terraform directory that manages a domain.

## Order of Execution

We need to use Terraform, Ansible, Helm and kubectl to deploy the infrastructure:

1. We are creating SSH keys, network, and nodes in Hetzner Cloud with Terraform
2. Ansible will deploy K3s on the nodes
3. On K3s0, we will deploy Cilium and ArgoCD
4. Apply K3s0 [App of Apps](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/blob/master/cluster/k3s0-ops/helm/aoa.yaml) to finish the setup and bootstrap
5. Add K3s1 cluster to ArgoCD
6. Apply k3s1 [App of Apps](https://github.com/Ujstor/k3s-single-node-multi-cluster-iac/blob/master/cluster/k3s1-app/helm/aoa.yaml) in k3s0 to deploy the K3s1 cluster

## Helm charts configuration

The Helm charts are configured in values.yaml and are imported as dependencies from a repository. They contain my personal configuration, but you can modify them to suit your needs.
Do not blindly apply them - check every configuration. Each of them references my domain, and this repository is used as a production GitOps repository.

## Project tree

```bash
[4.0K]  ./
├── [4.0K]  cluster/
│   ├── [4.0K]  k3s0-ops/
│   │   └── [4.0K]  helm/
│   │       ├── [4.0K]  app-of-apps/
│   │       │   ├── [ 595]  100_system_cilium.yaml
│   │       │   ├── [ 734]  110_system_metallb_operator.yaml
│   │       │   ├── [ 738]  120_system_metallb_config.yaml
│   │       │   ├── [ 760]  150_system_ingress_nginx.yaml
│   │       │   ├── [ 763]  200_system_cert_manager.yaml
│   │       │   ├── [ 739]  300_system_cluster_issuer.yaml
│   │       │   ├── [ 681]  410_system_minio_operator.yaml
│   │       │   ├── [ 685]  420_system_gitlab_operator.yaml
│   │       │   ├── [ 689]  500_system_external_secrets.yaml
│   │       │   ├── [ 649]  600_system_argocd.yaml
│   │       │   ├── [ 730]  700_system_prometheus_grafana.yaml
│   │       │   ├── [ 640]  900_app_gitea.yaml
│   │       │   ├── [ 665]  910_app_uptime_kuma.yaml
│   │       │   ├── [ 661]  920_app_mailserver.yaml
│   │       │   ├── [ 683]  970_app_harbor.yaml
│   │       │   ├── [ 645]  980_app_gitlab.yaml
│   │       │   ├── [ 698]  990_app_s3_storage.yaml
│   │       │   └── [ 622]  AppProject.yaml
│   │       ├── [4.0K]  apps/
│   │       │   ├── [4.0K]  gitea/
│   │       │   ├── [4.0K]  gitlab/
│   │       │   ├── [4.0K]  harbor/
│   │       │   ├── [4.0K]  mailserver/
│   │       │   ├── [4.0K]  s3-storage/
│   │       │   └── [4.0K]  uptime-kuma/
│   │       ├── [4.0K]  system/
│   │       │   ├── [4.0K]  argocd/
│   │       │   ├── [4.0K]  cert-manager/
│   │       │   ├── [4.0K]  cilium/
│   │       │   ├── [4.0K]  cluster-issuer/
│   │       │   ├── [4.0K]  external-secrets/
│   │       │   ├── [4.0K]  gitlab-operator/
│   │       │   ├── [4.0K]  ingress-nginx/
│   │       │   ├── [4.0K]  metallb-config/
│   │       │   ├── [4.0K]  metallb-operator/
│   │       │   ├── [4.0K]  minio-operator/
│   │       │   └── [4.0K]  prometheus-grafana/
│   │       ├── [ 474]  aoa.yaml
│   │       ├── [ 373]  k3s1-cluster-secret-example.yaml
│   │       └── [2.0K]  k3s1-cluster-secret.yaml
│   └── [4.0K]  k3s1-app/
│       └── [4.0K]  helm/
│           ├── [4.0K]  app-of-apps/
│           │   ├── [ 551]  100_system_cilium.yaml
│           │   ├── [ 736]  110_system_metallb_operator.yaml
│           │   ├── [ 740]  120_system_metallb_config.yaml
│           │   ├── [ 762]  150_system_ingress_nginx.yaml
│           │   ├── [ 765]  200_system_cert_manager.yaml
│           │   ├── [ 741]  300_system_cluster_issuer.yaml
│           │   ├── [ 724]  400_system_postgres_operator.yaml
│           │   ├── [ 683]  410_system_minio_operator.yaml
│           │   ├── [ 691]  500_system_external_secrets.yaml
│           │   ├── [ 659]  900_app_portfolio.yaml
│           │   ├── [ 699]  910_app_github_readme_stats_api.yaml
│           │   ├── [ 671]  920_app_streamlit_wh.yaml
│           │   ├── [ 655]  925_app_probit_api.yaml
│           │   ├── [ 786]  930_app_todo_go_htmx.yaml
│           │   ├── [ 651]  935_app_fastapi.yaml
│           │   ├── [ 667]  940_app_notes_flask.yaml
│           │   ├── [ 667]  945_app_todo_django.yaml
│           │   ├── [ 926]  950_app_plausible_analytics.yaml
│           │   └── [ 668]  960_app_wordpress_ds.yaml
│           ├── [4.0K]  apps/
│           │   ├── [4.0K]  fastapi/
│           │   ├── [4.0K]  github-readme-stats/
│           │   ├── [4.0K]  notes-flask/
│           │   ├── [4.0K]  plausible-analytics/
│           │   ├── [4.0K]  portfolio/
│           │   ├── [4.0K]  probit-api/
│           │   ├── [4.0K]  streamlit-wh/
│           │   ├── [4.0K]  todo-django/
│           │   ├── [4.0K]  todo-go-htmx/
│           │   └── [4.0K]  wordpress-ds/
│           ├── [4.0K]  system/
│           │   ├── [4.0K]  cert-manager/
│           │   ├── [4.0K]  cilium/
│           │   ├── [4.0K]  cluster-issuer/
│           │   ├── [4.0K]  external-secrets/
│           │   ├── [4.0K]  ingress-nginx/
│           │   ├── [4.0K]  metallb-config/
│           │   ├── [4.0K]  metallb-operator/
│           │   ├── [4.0K]  minio-operator/
│           │   ├── [4.0K]  postgres-operator/
│           │   └── [4.0K]  prometheus-grafana/
│           ├── [ 474]  aoa.yaml
│           └── [ 805]  serviceAcc.yaml
├── [4.0K]  iac/
│   ├── [4.0K]  ansible/
│   │   ├── [4.0K]  k3s-deploy/
│   │   │   ├── [4.0K]  roles/
│   │   │   │   └── [4.0K]  common/
│   │   │   ├── [ 239]  ansible.cfg
│   │   │   ├── [ 459]  Dockerfile
│   │   │   ├── [1.4K]  k3s_deploy.yml
│   │   │   ├── [ 207]  k3s_remove.yml
│   │   │   └── [ 169]  requirements.yml
│   │   └── [ 827]  inventory_k3s_deploy.yml
│   └── [4.0K]  terraform/
│       ├── [4.0K]  cloudflare-dns-astipan/
│       │   ├── [  65]  dependencies.tf
│       │   ├── [1.7K]  main.tf
│       │   ├── [ 847]  terrafrom.tf
│       │   └── [ 329]  variables.tf
│       ├── [4.0K]  cloudflare-dns-ds/
│       │   ├── [  65]  dependencies.tf
│       │   ├── [ 551]  main.tf
│       │   ├── [ 842]  terrafrom.tf
│       │   └── [ 329]  variables.tf
│       ├── [4.0K]  nodes-infra/
│       │   ├── [2.4K]  cloudflare_dns.tf
│       │   ├── [1.8K]  main.tf
│       │   ├── [ 142]  output.tf
│       │   ├── [   0]  terraform.tfstate
│       │   ├── [ 37K]  terraform.tfstate.backup
│       │   ├── [ 911]  terrafrom.tf
│       │   └── [ 329]  variables.tf
│       ├── [4.0K]  s3-kubeconfig-backup/
│       │   ├── [ 649]  main.tf
│       │   ├── [ 120]  outputs.tf
│       │   ├── [ 895]  terraform.tf
│       │   └── [ 159]  variables.tf
│       ├── [4.0K]  s3-ssh-keys-backup/
│       │   ├── [ 613]  main.tf
│       │   ├── [ 120]  outputs.tf
│       │   ├── [ 896]  terraform.tf
│       │   ├── [   0]  terraform.tfstate
│       │   ├── [6.5K]  terraform.tfstate.backup
│       │   └── [ 157]  variables.tf
│       └── [4.0K]  s3-tf-state/
│           ├── [ 254]  main.tf
│           ├── [ 120]  outputs.tf
│           ├── [ 427]  terraform.tf
│           ├── [3.0K]  terraform.tfstate
│           ├── [3.0K]  terraform.tfstate.backup
│           └── [ 165]  variables.tf
├── [ 191]  docker-config.yml
├── [2.6K]  docker_tag.sh*
├── [1.0K]  LICENSE
├── [2.2K]  Makefile
└── [1.6K]  README.md
```
