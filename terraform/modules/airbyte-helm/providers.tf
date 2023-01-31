terraform {
  required_providers {
    airbyte = {
      source  = "eabrouwer3/airbyte"
      version = "0.1.19"
    }
  }
}

provider "airbyte" {
  host_url = "http://192.168.15.161:80"
  username = "airbyte"
  password = "password"
  #   additional_headers = {
  #     Host = "airbyte.internal"
  #   }
  #   timeout = 120
}

