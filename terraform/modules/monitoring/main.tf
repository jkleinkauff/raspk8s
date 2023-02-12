resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

module "monitoring" {
  # source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/kube-prometheus-stack"
  source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name      = "monitoring"
  namespace = kubernetes_namespace.monitoring.metadata.0.name
  values    = file("${path.module}/values.yaml")
}