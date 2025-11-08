variable "aws_region" { type = string }

# ##############################
# VPC
# ##############################
variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }
variable "vpc_subnet" {
  description = "A map of subnet configurations."
  type = map(object({
    subnet_name = string
    cidr_block  = string
    az_suffix   = string
  }))
}

# ##############################
# Load Balancer
# ##############################
variable "lb_name" { type = string }
variable "lb_sg_name" { type = string }
variable "lb_tg_name" { type = string }
variable "lb_tg_protocol" { type = string }
variable "lb_tg_port" { type = string }
variable "lb_tg_health_check" {
  type    = string
  default = "/"
}

# ##############################
# ECS
# ##############################
variable "ecs_name" { type = string }
variable "ecs_task_name" { type = string }
# variable "ecs_template_file" { type = string }
variable "ecs_fargate_cpu" { type = number }
variable "ecs_fargate_memory" { type = number }
variable "ecs_con_name" { type = string }
variable "ecs_con_port" { type = string }
variable "ecs_service_name" { type = string }
variable "ecs_service_desired_count" { type = number }


# variable "ecs_task_sg" { type = string }

