resource "kubernetes_persistent_volume_claim_v1" "pvc-pg-airbyte-bkp" {
  metadata {
    name      = "bkp-pvc-pg-airbyte-bkp"
    namespace = local.namespace #kubernetes_namespace.airbyte.metadata.0.name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  wait_until_bound = false
}

resource "helm_release" "postgres" {
  name      = "pg-airbyte"
  chart     = "./custom-charts/kubegress-deploy"
  namespace = local.namespace #kubernetes_namespace.airbyte.metadata.0.name

  values           = [file("${path.module}/values-db.yaml")]
  timeout          = 600
  disable_webhooks = true

  set {
    name  = "pvc_bkp_name"
    value = kubernetes_persistent_volume_claim_v1.pvc-pg-airbyte-bkp.metadata.0.name
  }
}

resource "kubernetes_service" "pg-airbyte-external-svc" {
  metadata {
    name      = "pg-airbyte-external-nodeport"
    namespace = local.namespace #kubernetes_namespace.airbyte.metadata.0.name
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