terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 3.0"
  region = var.region
}

module "infra" {
  source = "../../../modules/infra"

  region = var.region
  aws_profile = var.aws_profile
  database_name = var.database_name
  env = var.env
}