resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

# resource "kubernetes_persistent_volume_claim_v1" "pvc-pg-airflow-bkp" {
#   metadata {
#     name      = "bkp-pvc-pg-airflow-bkp"
#     namespace = kubernetes_namespace.airflow.metadata.0.name
#   }
#   spec {
#     access_modes       = ["ReadWriteOnce"]
#     storage_class_name = "local-path"
#     resources {
#       requests = {
#         storage = "5Gi"
#       }
#     }
#   }
#   wait_until_bound = false
# }

resource "helm_release" "postgres" {
  name      = "pg-airflow"
  chart     = "./custom-charts/kubegress-deploy"
  namespace = kubernetes_namespace.airflow.metadata.0.name

  values           = [file("${path.module}/values-db.yaml")]
  timeout          = 600
  disable_webhooks = true

  # set {
  #   name  = "pvc_bkp_name"
  #   value = kubernetes_persistent_volume_claim_v1.pvc-pg-airflow-bkp.metadata.0.name
  # }
}


data "kubernetes_service" "pg-airflow" {
  metadata {
    name      = helm_release.postgres.name
    namespace = kubernetes_namespace.airflow.metadata.0.name
  }
}

output "svc-pg-airflow-uuid" {
  # value = data.kubernetes_service.pg-airflow.metadata.ownerReferences.0.uid
  value = data.kubernetes_service.pg-airflow.id
}

resource "kubernetes_service" "pg-airflow-external-svc" {
  metadata {
    name      = "pg-airflow-external-nodeport"
    namespace = kubernetes_namespace.airflow.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.postgres.name
      replicationRole = "primary"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32282
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "pg-airflow-replica-external-svc" {
  metadata {
    name      = "pg-airflow-replica-external-nodeport"
    namespace = kubernetes_namespace.airflow.metadata.0.name
  }
  spec {
    selector = {
      app             = helm_release.postgres.name
      replicationRole = "replica"
    }
    session_affinity = "None"
    port {
      port      = 5432
      node_port = 32288
    }

    type = "NodePort"
  }
}
