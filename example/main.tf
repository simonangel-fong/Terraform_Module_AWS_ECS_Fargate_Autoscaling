module "vpc" {
  source     = "../module"
  aws_region = var.aws_region
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr
  vpc_subnet = var.vpc_subnet
  ecs_name   = var.ecs_name
}
