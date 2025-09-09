TF_DIR=.
KUBECONFIG_FILE=$(TF_DIR)/kubeconfig.yaml

.PHONY: init plan up down kube clean

## Initialize Terraform providers and modules
init:
	@echo "🔧 Initializing Terraform..."
	cd $(TF_DIR) && terraform init

## Run Terraform plan
plan: init
	@echo "📝 Running Terraform plan..."
	cd $(TF_DIR) && terraform plan

## Deploy the cluster and show node status
up: init
	@echo "🚀 Deploying UpCloud K3s cluster..."
	cd $(TF_DIR) && terraform apply -auto-approve
	@echo "⏳ Waiting a few seconds before checking cluster..."
	sleep 20
	@if [ -f "$(KUBECONFIG_FILE)" ]; then \
		echo "✅ Checking cluster status..."; \
		KUBECONFIG=$(KUBECONFIG_FILE) kubectl get nodes; \
	else \
		echo "❌ kubeconfig not found at $(KUBECONFIG_FILE)."; \
	fi

## Destroy the cluster
down:
	@echo "💥 Destroying UpCloud K3s cluster..."
	cd $(TF_DIR) && terraform destroy -auto-approve

## Run kubectl with the generated kubeconfig
kube:
	@if [ ! -f "$(KUBECONFIG_FILE)" ]; then \
		echo "❌ kubeconfig not found at $(KUBECONFIG_FILE). Run 'make up' first."; \
		exit 1; \
	fi
	KUBECONFIG=$(KUBECONFIG_FILE) kubectl $(CMD)

## Clean local files
clean:
	@echo "🧹 Cleaning kubeconfig and token..."
	rm -f $(TF_DIR)/kubeconfig.yaml $(TF_DIR)/k3s_token.txt
