resource "tls_private_key" "git_dags" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
