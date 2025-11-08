module "demo_ecs" {
  source     = "../module"
  aws_region = var.aws_region
  # vpc
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr
  vpc_subnet = var.vpc_subnet

  # lb
  lb_name        = var.lb_name
  lb_sg_name     = var.lb_sg_name
  lb_tg_name     = var.lb_tg_name
  lb_tg_protocol = var.lb_tg_protocol
  lb_tg_port     = var.lb_tg_port

  # ecs
  ecs_name                  = var.ecs_name
  ecs_task_name             = var.ecs_task_name
  ecs_fargate_cpu           = var.ecs_fargate_cpu
  ecs_fargate_memory        = var.ecs_fargate_memory
  ecs_con_name              = var.ecs_con_name
  ecs_con_port              = var.ecs_con_port
  ecs_service_name          = var.ecs_service_name
  ecs_service_desired_count = var.ecs_service_desired_count
}
