#terraform {
#  backend "s3" {
#    profile = "backend"
#    encrypt = true
#    bucket  = "inpost-web-terraform-state"
#    region  = "eu-west-1"
#    key     = "web/terraform.tfstate"
#
#    dynamodb_table = "terraform-state-lock-dynamo"
#  }
#}

provider "aws" {
  region = "us-east-1"
}

locals {
  vpc_cider_block = "10.0.0.0/16"
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "my-db-passowrd" # As stored in the AWS Secrets Manager
}

# Give a meaningful name to the version for easy identification
# If multiple secrets are present
data "aws_secretsmanager_secret_version" "db_latest_ver" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = local.vpc_cider_block
}

module "webserver" {
  source                = "./modules/webserver"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnets
  instance_type         = "t2.micro"
  name_of_launch_config = "web-launch-configuration"
  launch_config_ami     = "ami-0c55b159cbfafe1f0"
  lb_name               = "web-lb"
  lb_type               = "application"
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  db_name_identifier = "mydatabase"
  db_username        = "admin"
  db_password        = jsondecode(data.aws_secretsmanager_secret_version.db_latest_ver.secret_string)
  db_name            = "mydatabase"
  cidr_to_allow      = [local.vpc_cider_block]
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = "my-app-storage-bucket"
}
