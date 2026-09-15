provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = var.project
      ManagedBy = "terraform"
      Repo      = "auto-repair-infra-database"
    }
  }
}

data "terraform_remote_state" "k8s" {
  backend = "s3"

  config = {
    bucket = "auto-repair-tfstate-814623398856"
    key    = "infra-k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id             = data.terraform_remote_state.k8s.outputs.vpc_id
  vpc_cidr           = data.terraform_remote_state.k8s.outputs.vpc_cidr
  private_subnet_ids = data.terraform_remote_state.k8s.outputs.private_subnet_ids
}
