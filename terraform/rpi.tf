module "metalb" {
  source = "./metalb"
}

module "nginx" {
  source = "./nginx"
}

module "git_keys" {
  source = "./modules/git_keys"
}

# module "airbyte" {
#   source = "./modules/airbyte-helm"
# }

# module "airflow" {
#   source   = "./modules/airflow-helm"
#   id_rsa   = module.git_keys.private_key
#   open_ssh = module.git_keys.open_ssh
# }

# module "monitoring" {
#   source = "./modules/monitoring"
# }

# module "jhodb" {
#   source = "./modules/jho-db"
# }

# module "hmsdb" {
#   source = "./modules/hms-db"
# }

# module "kafka" {
#   source = "/Volumes/Apple/development/raspfiles/bare_metal_infra/kafka"
#   #   source = "github.com/jkleinkauff/bare_metal_infra/kafka"

#   name      = "kafka"
#   namespace = "kafka"

#   host = "192.168.15.160"
#   deply_kafka_connect = false
#   kafka_connect_output_inmage = "kleinkauff/my-connect-cluster:latest"
#   docker_sm_secret = "docker/redcred"
# }

# module "trino" {
#   source = "./modules/trino"
# }

# module "redshift" {
#   source = "./aws-resources/redshift"
# }