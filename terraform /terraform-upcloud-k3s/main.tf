# Wait until cluster responds
resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.fetch_kubeconfig]

  provisioner "local-exec" {
    command = <<EOT
    for i in {1..30}; do
      KUBECONFIG=${path.module}/kubeconfig.yaml kubectl get nodes && exit 0
      echo "⏳ Cluster not ready yet, retrying in 10s"
      sleep 10
    done
    echo "❌ Cluster did not become ready"
    exit 1
    EOT
  }
}

# Traefik ingress
resource "helm_release" "traefik" {
  depends_on = [null_resource.wait_for_cluster]

  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "27.0.2"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

# cert-manager
resource "helm_release" "cert_manager" {
  depends_on = [null_resource.wait_for_cluster]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.15.3"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
