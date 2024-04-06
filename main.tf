provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./vpc"
}

module "ecs" {
  source    = "./ecs"
  vpc_id    = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}

module "iam" {
  source = "./iam"
}

output "nginx_public_ip" {
  value = module.ecs.nginx_public_ip
}

