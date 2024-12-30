all: update-repos k3s0 k3s1 k3s2 k3s5

k3s0: build_system_k3s0 build_apps_k3s0
k3s1: build_system_k3s1 build_apps_k3s1
k3s2: build_system_k3s2 build_apps_k3s2
k3s5: build_system_k3s5 build_apps_k3s5

update-repos:
	@echo "Updating Helm repositories..."
	@helm repo update

# Paths
CHART_DIR_SYSTEM_K3S0 := cluster/k3s0-ops/helm/system
CHART_DIR_APPS_K3S0 := cluster/k3s0-ops/helm/apps

CHART_DIR_SYSTEM_K3S1 := cluster/k3s1-app/helm/system
CHART_DIR_APPS_K3S1 := cluster/k3s1-app/helm/apps

CHART_DIR_SYSTEM_K3S2 := cluster/k3s2-win/helm/system
CHART_DIR_APPS_K3S2 := cluster/k3s2-win/helm/apps

CHART_DIR_SYSTEM_K3S5 := cluster/k3s5-test/helm/system
CHART_DIR_APPS_K3S5 := cluster/k3s5-test/helm/apps

# k3s0-ops cluster packages
CHART_SYSTEM_K3S0 := cert-manager cilium ingress-nginx argocd cluster-issuer external-secrets minio-operator gitlab-operator metallb-operator metallb-config prometheus-grafana
CHART_APPS_K3S0 := harbor gitlab s3-storage gitea uptime-kuma mailserver

# k3s1-app cluster packages
CHART_SYSTEM_K3S1 := cert-manager cilium ingress-nginx cluster-issuer external-secrets postgres-operator minio-operator metallb-operator metallb-config prometheus-grafana
CHART_APPS_K3S1 := portfolio streamlit-wh todo-go-htmx notes-flask plausible-analytics wordpress-ds probit-api github-readme-stats todo-django fastapi

# k3s2-win cluster packages
CHART_SYSTEM_K3S2 := cert-manager cilium ingress-nginx external-secrets metallb-operator metallb-config prometheus-grafana
CHART_APPS_K3S2 := k8s-win

# k3s5-win cluster packages
CHART_SYSTEM_K3S5 := cert-manager cilium ingress-nginx cluster-issuer external-secrets metallb-operator metallb-config istio
CHART_APPS_K3S5 := servicemesh-app

# Define pattern rules for k3s0
build_system_k3s0: $(addprefix k3s0-system-,$(CHART_SYSTEM_K3S0))
build_apps_k3s0: $(addprefix k3s0-apps-,$(CHART_APPS_K3S0))

k3s0-system-%:
	@echo "Packaging $* chart for k3s0 system..."
	@helm dependency build --skip-refresh $(CHART_DIR_SYSTEM_K3S0)/$* || helm dependency update --skip-refresh $(CHART_DIR_SYSTEM_K3S0)/$*

k3s0-apps-%:
	@echo "Packaging $* chart for k3s0 apps..."
	@helm dependency build --skip-refresh $(CHART_DIR_APPS_K3S0)/$* || helm dependency update --skip-refresh $(CHART_DIR_APPS_K3S0)/$*

# Define pattern rules for k3s1
build_system_k3s1: $(addprefix k3s1-system-,$(CHART_SYSTEM_K3S1))
build_apps_k3s1: $(addprefix k3s1-apps-,$(CHART_APPS_K3S1))

k3s1-system-%:
	@echo "Packaging $* chart for k3s1 system..."
	@helm dependency build --skip-refresh $(CHART_DIR_SYSTEM_K3S1)/$* || helm dependency update --skip-refresh $(CHART_DIR_SYSTEM_K3S1)/$*

k3s1-apps-%:
	@echo "Packaging $* chart for k3s1 apps..."
	@helm dependency build --skip-refresh $(CHART_DIR_APPS_K3S1)/$* || helm dependency update --skip-refresh $(CHART_DIR_APPS_K3S1)/$*

# Define pattern rules for k3s2
build_system_k3s2: $(addprefix k3s2-system-,$(CHART_SYSTEM_K3S2))
build_apps_k3s2: $(addprefix k3s2-apps-,$(CHART_APPS_K3S2))

k3s2-system-%:
	@echo "Packaging $* chart for k3s2 system..."
	@helm dependency build --skip-refresh $(CHART_DIR_SYSTEM_K3S2)/$* || helm dependency update --skip-refresh $(CHART_DIR_SYSTEM_K3S2)/$*

k3s2-apps-%:
	@echo "Packaging $* chart for k3s2 apps..."
	@helm dependency build --skip-refresh $(CHART_DIR_APPS_K3S2)/$* || helm dependency update --skip-refresh $(CHART_DIR_APPS_K3S2)/$*

# Define pattern rules for k3s5
build_system_k3s5: $(addprefix k3s5-system-,$(CHART_SYSTEM_K3S5))
build_apps_k3s5: $(addprefix k3s5-apps-,$(CHART_APPS_K3S5))

k3s5-system-%:
	@echo "Packaging $* chart for k3s5 system..."
	@helm dependency build --skip-refresh $(CHART_DIR_SYSTEM_K3S5)/$* || helm dependency update --skip-refresh $(CHART_DIR_SYSTEM_K3S5)/$*

k3s5-apps-%:
	@echo "Packaging $* chart for k3s5 apps..."
	@helm dependency build --skip-refresh $(CHART_DIR_APPS_K3S5)/$* || helm dependency update --skip-refresh $(CHART_DIR_APPS_K3S5)/$*


.PHONY: all k3s0 k3s1 build_system_k3s0 build_apps_k3s0 build_system_k3s1 build_apps_k3s1 build_system_k3s2 build_apps_k3s2 update-repos build_system_k3s5 build_apps_k3s5
