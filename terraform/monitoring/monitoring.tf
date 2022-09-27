resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus-stack" {
  name = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace = kubernetes_namespace.monitoring.metadata.0.name

  values = [file("${path.module}/values.yaml")]

  timeout          = 300
  disable_webhooks = true
}

resource "kubernetes_ingress_v1" "ingress-grafana" {
  depends_on = [
    helm_release.kube-prometheus-stack
  ]

  metadata {
    name      = "grafana-web"
    namespace = kubernetes_namespace.monitoring.metadata.0.name
    annotations = {
      # "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = true
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$2"
    }

    labels = {
      app = "grafana"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "monitoring-grafana"
              port {
                number = 80
              }
            }
          }

          path      = "/grafana(/|$)(.*)"
          path_type = "ImplementationSpecific"

        }
      }
    }

    ingress_class_name = "nginx"

  }

}