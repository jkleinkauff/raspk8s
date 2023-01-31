output "private_key" {
  value = tls_private_key.git_dags.private_key_pem
}

output "open_ssh" {
  value = tls_private_key.git_dags.public_key_openssh
}
