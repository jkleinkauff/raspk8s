resource "helm_release" "airflow" {
  name = "airflow"

  repository = "https://airflow-helm.github.io/charts"
  chart      = "airflow"
  version    = "8.6.1"

  namespace = var.airflow_ns

  values           = [file("${path.module}/values.yaml")]
  timeout          = 320
  disable_webhooks = true

  depends_on = [
    helm_release.postgres
  ]

  // Airflow Connections
  set {
    name  = "airflow.connections[0].id"
    value = "aws"
  }

  set {
    name  = "airflow.connections[0].type"
    value = "aws"
  }

  set {
    name  = "airflow.connections[0].login"
    value = aws_iam_access_key.airflow.id
  }

  set_sensitive {
    name  = "airflow.connections[0].password"
    value = aws_iam_access_key.airflow.secret
  }

  set {
    name  = "airflow.config.AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER"
    value = "s3://${aws_s3_bucket.logs.bucket}"
  }

}