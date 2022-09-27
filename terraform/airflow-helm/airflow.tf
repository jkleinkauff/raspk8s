resource "helm_release" "airflow" {
  name = "airflow"

  repository = "https://airflow-helm.github.io/charts"
  chart      = "airflow"
  version    = "8.6.1"

  namespace = var.airflow_ns

  values           = [file("${path.module}/values.yaml")]
  timeout          = 360
  disable_webhooks = true

  depends_on = [
    helm_release.postgres
  ]
}