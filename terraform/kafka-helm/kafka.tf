resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

resource "helm_release" "kafka-strimzi" {
  name = "kafka-strimzi"

  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  namespace  = kubernetes_namespace.kafka.metadata.0.name

  timeout          = 600
  disable_webhooks = true
}

resource "helm_release" "kafka" {
  name      = "kafka"
  chart     = "./custom-charts/kafka-deploy"
  namespace = kubernetes_namespace.kafka.metadata.0.name

  values           = [file("${path.module}/values.yaml")]
  timeout          = 600
  disable_webhooks = true

  depends_on = [
    helm_release.kafka-strimzi
  ]
}