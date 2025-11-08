module "demo_ecs" {
  source     = "../module"
  project    = var.project
  aws_region = var.aws_region
  # vpc
  vpc_cidr   = var.vpc_cidr
  vpc_subnet = var.vpc_subnet
  # ecs
  ecs_task_cpu    = var.ecs_task_cpu
  ecs_task_memory = var.ecs_task_memory
  ecs_svc_desired = var.ecs_svc_desired
  ecs_container   = var.ecs_container
  ecs_port        = var.ecs_port
  ecs_protocol    = var.ecs_protocol
}
