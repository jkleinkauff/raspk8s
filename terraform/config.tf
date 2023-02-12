terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "s3" {
    bucket  = "rpi-jho-tf-state"
    region  = "us-east-1"
    profile = "kkf-aws"
  }

  required_version = ">= 0.13"
}

provider "aws" {
  region  = "us-east-1"
  profile = "kkf-aws"
}

provider "kubernetes" {
  config_path = "/Users/jhonatas/.kube/jhok8s/config"
}

provider "helm" {
  kubernetes {
    config_path = "/Users/jhonatas/.kube/jhok8s/config"
  }
}

provider "kubectl" {
  config_path = "/Users/jhonatas/.kube/jhok8s/config"
  # host                   = var.eks_cluster_endpoint
  # cluster_ca_certificate = base64decode(var.eks_cluster_ca)
  # token                  = data.aws_eks_cluster_auth.main.token
  # load_config_file       = false
}

data "aws_caller_identity" "current" {}