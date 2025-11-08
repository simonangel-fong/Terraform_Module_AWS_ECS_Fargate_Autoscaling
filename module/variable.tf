# ##############################
# APP
# ##############################
variable "project" { type = string }

# ##############################
# AWS
# ##############################
variable "aws_region" { type = string }

# ##############################
# VPC
# ##############################
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
variable "lb_health_check_path" {
  type    = string
  default = "/"
}

# ##############################
# AWS ECS
# ##############################
# variable "ecs_template_file" { type = string }
variable "ecs_task_cpu" { type = number }
variable "ecs_task_memory" { type = number }
variable "ecs_svc_desired" { type = number }
variable "ecs_container_name" { type = string }
variable "ecs_container_file" { type = string }
variable "ecs_port" { type = string }
variable "ecs_protocol" { type = string }
