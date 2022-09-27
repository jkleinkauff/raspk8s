module "metalb" {
  source = "./metalb"
}

module "nginx" {
  source = "./nginx"
}

# module "pg-airflow" {
#   source = "./pg-airflow"
# }

module "airflow" {
  source     = "./airflow-helm"
  airflow_ns = "airflow"
}

# module "airbyte" {
#   source     = "./airbyte-helm"
# }

module "kafka" {
  source = "./kafka-helm"
}

module "monitoring" {
  source = "./monitoring"
}

# module "pg-airbyte" {
#   source = "./pg-airbyte"
# }
