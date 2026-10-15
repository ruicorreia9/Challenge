terraform {
  required_version = ">= 1.16.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
  }
}

provider "aws" {
  region = data.terraform_remote_state.infra.outputs.region
}

provider "kubernetes" {
  host                   = "https://127.0.0.1:8443" //SSM
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_certificate_authority_data)
  tls_server_name        = replace(data.terraform_remote_state.infra.outputs.cluster_endpoint, "https://", "")

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.infra.outputs.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://127.0.0.1:8443" //SSM
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_certificate_authority_data)
    tls_server_name        = replace(data.terraform_remote_state.infra.outputs.cluster_endpoint, "https://", "")

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.infra.outputs.cluster_name]
    }
  }
}

