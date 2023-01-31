module "metalb" {
  source = "./metalb"
}

module "nginx" {
  source = "./nginx"
}

module "git_keys" {
  source = "./modules/git_keys"
}

module "airbyte" {
  source = "./modules/airbyte-helm"
}

# module "airflow" {
#   source   = "./modules/airflow-helm"
#   id_rsa   = module.git_keys.private_key
#   open_ssh = module.git_keys.open_ssh
# }

module "monitoring" {
  source = "./monitoring"

  deploy_kafka_pod_monitors = true
}

module "jhodb" {
  source = "./modules/jho-db"
}

# module "trino" {
#   source = "./trino-helm"
# }

# module "exploredb" {
#   source = "./explore-db"
# }

module "kafka" {
  source = "./modules/kafka"

  # deploy_debezium_connector = true
  # deploy_sink_s3            = true
}

# module "redshift" {
#   source = "./aws-resources/redshift"
# }

