resource "helm_release" "nginx" {
  name       = "nginx-helm"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.2.3"

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "controller.publishService.enabled"
    value = true
  }

  set {
    name  = "controller.extraArgs.enable-ssl-passthrough"
    value = true
  }
}

