resource "kubernetes_namespace" "exploredb" {
  metadata {
    name = "exploredb"
  }
}

resource "helm_release" "exploredb" {
  name      = "pg-exploredb"
  chart     = "./custom-charts/kubegress-deploy"
  namespace = kubernetes_namespace.exploredb.metadata.0.name

  values           = [file("${path.module}/values-db.yaml")]
  timeout          = 600
  disable_webhooks = true
}


data "kubernetes_service" "pg-exploredb" {
  metadata {
    name      = helm_release.exploredb.name
    namespace = kubernetes_namespace.exploredb.metadata.0.name
  }
}

output "svc-pg-exploredb-uuid" {
  value = data.kubernetes_service.pg-exploredb.id
}

resource "kubernetes_service" "pg-exploredb-external-svc" {
  metadata {
    name      = "pg-exploredb-external-nodeport"
    namespace = kubernetes_namespace.exploredb.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.exploredb.name
      replicationRole = "primary"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32285
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "pg-exploredb-replica-external-svc" {
  metadata {
    name      = "pg-exploredb-replica-external-nodeport"
    namespace = kubernetes_namespace.exploredb.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.exploredb.name
      replicationRole = "replica"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32291
    }

    type = "NodePort"
  }
}
