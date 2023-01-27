module "metalb" {
  source = "./metalb"
}

module "nginx" {
  source = "./nginx"
}

module "infra" {
  source = "./infra"
}

# module "airflow" {
#   source     = "./airflow-helm"
#   airflow_ns = "airflow"

#   tls_key = module.infra.tls-git-ssh-key
# }

# module "airbyte" {
#   source = "./airbyte-helm"
# }

module "monitoring" {
  source = "./monitoring"

  deploy_kafka_pod_monitors = true
}

# module "jhodb" {
#   source = "./modules/jho-db"
# }

# module "trino" {
#   source = "./trino-helm"
# }

# module "exploredb" {
#   source = "./explore-db"
# }

# module "kafka" {
#   source = "./kafka-helm"

#   deploy_debezium_connector = true
#   deploy_sink_s3            = true
# }

# module "redshift" {
#   source = "./aws-resources/redshift"
# }

