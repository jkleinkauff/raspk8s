resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

module "kafka" {
  source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/kafka"
#   source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name            = "kafka"
  namespace       = kubernetes_namespace.kafka.metadata.0.name
}