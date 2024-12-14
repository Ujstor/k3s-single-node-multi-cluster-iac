all: k3s0 k3s1
k3s0: build_system_k3s0 build_apps_k3s0
k3s1: build_system_k3s1 build_apps_k3s1

# Paths
CHART_DIR_SYSTEM_K3S0 := cluster/k3s0-ops/helm/system
CHART_DIR_APPS_K3S0 := cluster/k3s0-ops/helm/apps

CHART_DIR_SYSTEM_K3S1 := cluster/k3s1-app/helm/system
CHART_DIR_APPS_K3S1 := cluster/k3s1-app/helm/apps

# k3s0-ops cluster packages
CHART_SYSTEM_K3S0 := cert-manager cilium ingress-nginx argocd cluster-issuer external-secrets minio-operator gitlab-operator metallb-operator metallb-config
CHART_APPS_K3S0 := harbor gitlab s3-storage gitea

# k3s1-app cluster packages
CHART_SYSTEM_K3S1 := cert-manager cilium ingress-nginx cluster-issuer external-secrets postgres-operator minio-operator metallb-operator metallb-config
CHART_APPS_K3S1 := portfolio streamlit-wh todo-go-htmx notes-flask plausible-analytics uptime-kuma wordpress-ds probit-api github-readme-stats todo-django fastapi

build_system_k3s0: $(CHART_SYSTEM_K3S0)
$(CHART_SYSTEM_K3S0):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_SYSTEM_K3S0)/$@ || helm dependency update $(CHART_DIR_SYSTEM_K3S0)/$@

build_apps_k3s0: $(CHART_APPS_K3S0)
$(CHART_APPS_K3S0):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_APPS_K3S0)/$@ || helm dependency update $(CHART_DIR_APPS_K3S0)/$@

build_system_k3s1: $(CHART_SYSTEM_K3S1)
$(CHART_SYSTEM_K3S1):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_SYSTEM_K3S1)/$@ || helm dependency update $(CHART_DIR_SYSTEM_K3S1)/$@

build_apps_k3s1: $(CHART_APPS_K3S1)
$(CHART_APPS_K3S1):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_APPS_K3S1)/$@ || helm dependency update $(CHART_DIR_APPS_K3S1)/$@

.PHONY: all k3s0 k3s1 build_system_k3s0 $(CHART_SYSTEM_K3S0) build_apps_k3s0 $(CHART_APPS_K3S0) build_system_k3s1 $(CHART_SYSTEM_K3S1) build_apps_k3s1 $(CHART_APPS_K3S1)
