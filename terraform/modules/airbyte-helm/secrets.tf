# resource "kubernetes_secret" "api-nginx" {
#   metadata {
#     name = "basic-auth"
#     namespace = local.namespace #kubernetes_namespace.airbyte.metadata.0.name
#   }

#   data = {
#     htpasswd = "jhonatas:$apr1$jvyqhdSs$R1ShDg5gY7JKumfag8wN7/"
#   }

# #   type = "kubernetes.io/basic-auth"
# }

# resource "kubernetes_config_map" "default-conf-nginx" {
#   metadata {
#     name = "default-conf-nginx"
#     namespace = local.namespace #kubernetes_namespace.airbyte.metadata.0.name
#   }

#   data = {
#     "nginx.conf" = "${file("${path.module}/nginx.conf")}"
#   }
# }