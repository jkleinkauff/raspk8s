resource "kubernetes_namespace" "jhodb" {
  metadata {
    name = "jhodb"
  }
}

module "jhodb" {
  # source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/db/kubegress"
  source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name            = "jodb"
  namespace       = kubernetes_namespace.jhodb.metadata.0.name
  size            = "2Gi"
  replicas        = 2
  enable_backup   = false
  wal_level       = "logical"
  db_name         = "jhodb"
  db_user         = "user_jhodb"
  db_password     = "jhodb"
  max_connections = 40

}