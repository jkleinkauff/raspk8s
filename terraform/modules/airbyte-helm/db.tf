module "airbyte_db" {
  # source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/db/kubegress"
  source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name            = "airbyte"
  namespace       = kubernetes_namespace.airbyte.metadata.0.name
  size            = "2Gi"
  replicas        = 2
  enable_backup   = false
  wal_level       = "logical"
  db_name         = "airbyte"
  db_user         = "user_airbyte"
  db_password     = "airbyte"
  max_connections = 105
}