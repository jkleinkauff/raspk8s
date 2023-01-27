data "aws_secretsmanager_secret" "redshift" {
  name = "redshift/credentials"
}

data "aws_secretsmanager_secret_version" "redshift" {
  secret_id = data.aws_secretsmanager_secret.redshift.id
}


resource "aws_redshift_cluster" "redshift-cluster" {
  cluster_identifier = "jho-redshift-cluster"
  database_name      = jsondecode(data.aws_secretsmanager_secret_version.redshift.secret_string)["dbname"]
  master_username    = jsondecode(data.aws_secretsmanager_secret_version.redshift.secret_string)["user"]
  master_password    = jsondecode(data.aws_secretsmanager_secret_version.redshift.secret_string)["password"]
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  # final_snapshot_identifier = "jho-redshift-cluster-snapshot"
  skip_final_snapshot = "true"
}