resource "kubernetes_namespace" "airflow_ns" {
  metadata {
    name = "airflow"
  }
}

resource "helm_release" "airflow-main" {
  name = "airflow"

  repository = "https://airflow-helm.github.io/charts"
  chart      = "airflow"
  version    = "8.6.1"

  namespace = kubernetes_namespace.airflow_ns.metadata.0.name

  # values           = [file("${path.module}/values.yaml")]
  values = [
    templatefile("${path.module}/values.yaml",
      {
        db_host     = module.airflow_db.db_host,
        db_name     = module.airflow_db.db_name,
        db_user     = module.airflow_db.db_user,
        db_password = module.airflow_db.db_password
    })
  ]

  timeout          = 350
  disable_webhooks = true

  depends_on = [
    module.airflow_db
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