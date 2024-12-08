# K3S Single Node IaC

Minimal k3s single node deployment on Hetzner Cloud with Terraform and Ansible.

## Terraform

```bash
cd terraform

terraform init
terraform apply
```

## Ansible

```bash
docker build -t ansible-k3s ./ansible

docker run --rm -it \
    -v $(pwd)/iac/ansible/inventory_k3s_deploy.yml:/config/inventory.yml \
    -v $(pwd)/terraform/.ssh/k3s_prod_hetzner_ssh_key:/secrets/ssh_key \
    -v $(pwd)/terraform/.ssh/k3s_prod_hetzner_ssh_key.pub:/secrets/ssh_key.pub \
    ansible-k3s

ansible-playbook playbook_k3s_deploy.yml

cat kubeconfig
```

or use the [prebuilt](https://hub.docker.com/repository/docker/ujstor/ansible-k3s-prod/general) image.

## Helm

### Add server ip to metalLB system helm chart

```bash
metallb-config:
  ipAddressPool:
    addresses:
     - 192.168.1.1/32

  l2Advertisement:
    enabled: true
```
push chages to the repo (argocd aoa)

### Install Cilium in the `kube-system` namespace:

```bash
cd cluster/k3s0-ops/helm/cilium
helm install cilium . -n kube-system
```

### Install Argo CD:
```bash
kubectl create namespace gitops
cd cluster/k3s0-ops/helm/argo-cd
helm install argocd . -n gitops
```

### Apply `aoa.yaml` in the `gitops` namespace:
```bash
cd helm
kubectl apply -f aoa.yaml -n gitops
``````

The cluster will be automatically bootstrapped.
