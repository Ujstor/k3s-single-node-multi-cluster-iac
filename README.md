# K3S Single Node Multi Cluster IaC

Minimal k3s single node deployment on Hetzner Cloud with Terraform and Ansible as multi cluster configuration managed with ArgoCD.

## Terraform

```bash
cd ./iac/terraform/nodes-infra/

terraform init
terraform apply
```

## Ansible

```bash
docker build -t ansible-k3s-single-node-multi-cluster ./iac/ansible/k3s-deploy

docker run --rm -it \
    -v $(pwd)/iac/ansible/inventory_k3s_deploy.yml:/config/inventory.yml \
    -v $(pwd)/iac/terraform/nodes-infra/.ssh/k3s_prod_hetzner_ssh_key:/secrets/ssh_key \
    -v $(pwd)/iac/terraform/nodes-infra/.ssh/k3s_prod_hetzner_ssh_key.pub:/secrets/ssh_key.pub \
    ansible-k3s-single-node-multi-cluster

cat kubeconfig
```

or use the [prebuilt](https://hub.docker.com/repository/docker/ujstor/ansible-k3s-single-node-multi-cluster/general) image.

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

k8s0
```bash
cd cluster/k3s0-ops/helm/cilium
helm install cilium . -n kube-system
```

k8s0
```bash
### Install Argo CD:
```bash
kubectl create namespace gitops
cd cluster/k3s0-ops/helm/argo-cd
helm install argocd . -n gitops
```

k8s0
```bash
### Apply `aoa.yaml` in the `gitops` namespace:
```bash
cd helm
kubectl apply -f cluster/k3s0-ops/helm/aoa.yaml -n gitops
```

```bash
argocd cluster add default --kubeconfig ~/.kube/k3s1-app --name default --grpc-web
```

or

k8s1
```bash
k apply -f k3s1-cluster-secret.yaml -n kube-system

ca=$(kubectl get -n kube-system secret/argocd-manager-token -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get -n kube-system secret/argocd-manager-token -o jsonpath='{.data.token}' | base64 --decode)
```

k8s0
```bash
k apply -f k3s1-cluster-secret.yaml -n gitops
```

k8s0
```bash
k apply k3s1/aoa.yaml -n gitops
```

The cluster will be automatically bootstrapped.
