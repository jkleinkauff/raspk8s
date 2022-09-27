resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = "airbyte"
  }
}

resource "helm_release" "postgres" {
  name      = "pg-airbyte"
  chart     = "./custom-charts/kubegress-deploy"
  namespace = kubernetes_namespace.airbyte.metadata.0.name

  values           = [file("${path.module}/values.yaml")]
  timeout          = 600
  disable_webhooks = true
  
}

resource "kubernetes_service" "pg-airbyte-external-svc" {
  metadata {
    name      = "pg-airbyte-external-nodeport"
    namespace = kubernetes_namespace.airbyte.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.postgres.name
      replicationRole = "primary"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32292
    }

    type = "NodePort"
  }
}