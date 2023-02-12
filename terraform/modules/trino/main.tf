resource "kubernetes_namespace" "trino" {
  metadata {
    name = "trino"
  }
}

resource "helm_release" "trino" {
  name = "trino"

  repository = "https://trinodb.github.io/charts/"
  chart      = "trino"
  version    = "0.9.0"

  namespace = "trino"

  values = [
    templatefile("${path.module}/values.yaml",
      {
        aws_access_key =  aws_iam_access_key.trino_glue_catalog_access_key.id
        aws_secret_key = aws_iam_access_key.trino_glue_catalog_access_key.secret
    })
  ]

  timeout = 230
}
