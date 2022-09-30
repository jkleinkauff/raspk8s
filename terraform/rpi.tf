module "metalb" {
  source = "./metalb"
}

module "nginx" {
  source = "./nginx"
}

module "infra" {
  source = "./infra"
}

module "airflow" {
  source     = "./airflow-helm"
  airflow_ns = "airflow"

  tls_key = module.infra.tls-git-ssh-key
}

# module "airbyte" {
#   source     = "./airbyte-helm"
# }

module "jhodb" {
  source = "./personal-db"
}

module "kafka" {
  source = "./kafka-helm"

  deploy_debezium_connector = true
}

module "monitoring" {
  source = "./monitoring"
}
