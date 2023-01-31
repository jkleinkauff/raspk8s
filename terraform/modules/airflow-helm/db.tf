module "airflow_db" {
  # source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/db/kubegress"
  source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name            = "airflow"
  namespace       = kubernetes_namespace.airflow_ns.metadata.0.name
  size            = "2Gi"
  replicas        = 2
  enable_backup   = false
  wal_level       = "logical"
  db_name         = "airflow"
  db_user         = "user_airflow"
  db_password     = "airflow"
  max_connections = 40
}