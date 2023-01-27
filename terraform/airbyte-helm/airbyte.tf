resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = "airbyte"
  }
}

resource "helm_release" "airbyte" {
  name = "airbyte"

  repository = "https://airbytehq.github.io/helm-charts"
  chart      = "airbyte"
  version    = "0.43.21"

  namespace = "airbyte" #kubernetes_namespace.airbyte.metadata.0.name

  values  = [file("${path.module}/values.yaml")]
  timeout = 230
  # disable_webhooks = true

  # depends_on = [
  #   helm_release.postgres
  # ]
}