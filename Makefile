all: build_system_ops build_apps_ops build_system_app build_apps_app
ops: build_system_ops build_apps_ops
app: build_system_app build_apps_app

# Paths (these are correct as per your note)
CHART_DIR_SYSTEM_OPS := cluster/k3s0-ops/helm/system
CHART_DIR_APPS_OPS := clusters/k3s0-ops/helm/apps
CHART_DIR_SYSTEM_APP := clusters/k3s1-app/helm/system
CHART_DIR_APPS_APP := cluster/k3s1-app/helm/apps

# k3s0-ops cluster packages
CHART_SYSTEM_OPS := cert-manager cilium ingress-nginx argocd cluster-issuer external-secrets minio-operator gitlab-operator metallb-operator metallb-config
CHART_APPS_OPS := harbor gitlab s3-storage gitea

# k3s1-app cluster packages
CHART_SYSTEM_APP := cert-manager cilium ingress-nginx cluster-issuer external-secrets postgres-operator minio-operator metallb-operator metallb-config
CHART_APPS_APP := portfolio streamlit-wh todo-go-htmx notes-flask plausible-analytics uptime-kuma wordpress-ds

build_system_ops: $(CHART_SYSTEM_OPS)
$(CHART_SYSTEM_OPS):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_SYSTEM_OPS)/$@ || helm dependency update $(CHART_DIR_SYSTEM_OPS)/$@

build_apps_ops: $(CHART_APPS_OPS)
$(CHART_APPS_OPS):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_APPS_OPS)/$@ || helm dependency update $(CHART_DIR_APPS_OPS)/$@

build_system_app: $(CHART_SYSTEM_APP)
$(CHART_SYSTEM_APP):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_SYSTEM_APP)/$@ || helm dependency update $(CHART_DIR_SYSTEM_APP)/$@

build_apps_app: $(CHART_APPS_APP)
$(CHART_APPS_APP):
	@echo "Packaging $@ chart..."
	@helm dependency build $(CHART_DIR_APPS_APP)/$@ || helm dependency update $(CHART_DIR_APPS_APP)/$@

.PHONY: all ops app build_system_ops $(CHART_SYSTEM_OPS) build_apps_ops $(CHART_APPS_OPS) build_system_app $(CHART_SYSTEM_APP) build_apps_app $(CHART_APPS_APP)
