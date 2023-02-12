resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = "airbyte"
  }
}

resource "helm_release" "airbyte" {
  name = "airbyte"

  repository = "https://airbytehq.github.io/helm-charts"
  chart      = "airbyte"
  version    = "0.43.24"

  namespace = kubernetes_namespace.airbyte.metadata.0.name

  values = [
    templatefile("${path.module}/values.yaml",
      {
        AWS_ACCESS_KEY_ID     = aws_iam_access_key.airbyte.id,
        AWS_SECRET_ACCESS_KEY = aws_iam_access_key.airbyte.secret,
        logs_bucket_name      = aws_s3_bucket.logs.id
        db_host               = module.airbyte_db.db_host,
        db_name               = module.airbyte_db.db_name
        # airbyte_sa_exists     = data.kubernetes_service_account_v1.airbyte-sa-admin
    })
  ]

  timeout = 500
}