resource "kubernetes_namespace" "hmsdb" {
  metadata {
    name = "hmsdb"
  }
}

module "hmsdb" {
  # source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/db/kubegress"
  source = "github.com/jkleinkauff/bare_metal_infra/db/kubegress"

  name            = "hmsdb"
  namespace       = kubernetes_namespace.hmsdb.metadata.0.name
  size            = "2Gi"
  replicas        = 2
  enable_backup   = false
  wal_level       = "logical"
  db_name         = "hmsdb"
  db_user         = "user_hmsdb"
  db_password     = "hmsdb"
  max_connections = 30
}
