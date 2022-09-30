data "aws_secretsmanager_secret" "redcred" {
  name = "docker/redcred"
}

data "aws_secretsmanager_secret_version" "redcred" {
  secret_id = data.aws_secretsmanager_secret.redcred.id
}


resource "kubernetes_secret" "redcred" {
  metadata {
    namespace = kubernetes_namespace.kafka.metadata.0.name
    name      = "redcred"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          "username" = jsondecode(data.aws_secretsmanager_secret_version.redcred.secret_string)["username"]
          "password" = jsondecode(data.aws_secretsmanager_secret_version.redcred.secret_string)["password"]
          "email"    = jsondecode(data.aws_secretsmanager_secret_version.redcred.secret_string)["email"]
          "auth"     = base64encode("${jsondecode(data.aws_secretsmanager_secret_version.redcred.secret_string)["username"]}:${jsondecode(data.aws_secretsmanager_secret_version.redcred.secret_string)["password"]}")
        }
      }
    })
  }
}