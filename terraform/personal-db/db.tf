resource "kubernetes_namespace" "jhodb" {
  metadata {
    name = "jhodb"
  }
}

resource "helm_release" "jhodb" {
  name      = "pg-jhodb"
  chart     = "./custom-charts/kubegress-deploy"
  namespace = kubernetes_namespace.jhodb.metadata.0.name

  values           = [file("${path.module}/values-db.yaml")]
  timeout          = 600
  disable_webhooks = true
}


data "kubernetes_service" "pg-jhodb" {
  metadata {
    name      = helm_release.jhodb.name
    namespace = kubernetes_namespace.jhodb.metadata.0.name
  }
}

output "svc-pg-jhodb-uuid" {
  value = data.kubernetes_service.pg-jhodb.id
}

resource "kubernetes_service" "pg-jhodb-external-svc" {
  metadata {
    name      = "pg-jhodb-external-nodeport"
    namespace = kubernetes_namespace.jhodb.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.jhodb.name
      replicationRole = "primary"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32284
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "pg-jhodb-replica-external-svc" {
  metadata {
    name      = "pg-jhodb-replica-external-nodeport"
    namespace = kubernetes_namespace.jhodb.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.jhodb.name
      replicationRole = "replica"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32290
    }

    type = "NodePort"
  }
}
