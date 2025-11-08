variable "aws_region" { type = string }

# ##############################
# AWS VPC
# ##############################
variable "vpc_name" { default = "demo-fargate-vpc" }

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_subnet" {
  type = map(object({
    subnet_name = string
    cidr_block  = string
    az_suffix   = string
  }))
  default = {
    public_subnet_1a = {
      subnet_name = "public_subnet"
      cidr_block  = "10.0.1.0/24"
      az_suffix   = "a"
    }
    public_subnet_1b = {
      subnet_name = "public_subnet"
      cidr_block  = "10.0.2.0/24"
      az_suffix   = "b"
    }
  }
}

# ##############################
# AWS ECS
# ##############################
variable "ecs_name" { default = "demo_fargate" }
variable "ecs_task_name" { default = "nginx" }
variable "ecs_fargate_cpu" { default = 1024 }
variable "ecs_fargate_memory" { default = 2048 }
variable "ecs_con_name" { default = "nginx" }
variable "ecs_con_port" { default = "80" }
variable "ecs_service_name" { default = "svc_nginx" }
variable "ecs_service_desired_count" { default = 1 }

# ##############################
# AWS ALB
# ##############################
variable "lb_name" { default = "demo-fargate-lb" }
variable "lb_sg_name" { default = "demo-fargate-lb-sg" }
variable "lb_tg_name" { default = "demo-fargate-lb-tg" }
variable "lb_tg_protocol" { default = "HTTP" }
variable "lb_tg_port" { default = "80" }
