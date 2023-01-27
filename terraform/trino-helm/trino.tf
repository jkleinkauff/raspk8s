resource "kubernetes_namespace" "trino" {
  metadata {
    name = "trino"
  }
}

resource "helm_release" "airbyte" {
  name = "trino"

  repository = "https://trinodb.github.io/charts/"
  chart      = "trino"
  version    = "0.9.0"

  namespace = "trino" #kubernetes_namespace.airbyte.metadata.0.name

  #   values           = [file("${path.module}/values.yaml")]
  timeout = 230
  # disable_webhooks = true

  # depends_on = [
  #   helm_release.postgres
  # ]
}