# ##############################
# APP
# ##############################
variable "project" { default = "demo-fargate" }

# ##############################
# AWS
# ##############################
variable "aws_region" { type = string }

# ##############################
# AWS VPC
# ##############################
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
variable "ecs_task_cpu" { default = 256 }
variable "ecs_task_memory" { default = 512 }
variable "ecs_svc_desired" { default = 1 }
variable "ecs_port" { default = "80" }
variable "ecs_protocol" { default = "HTTP" }
variable "ecs_container_name" { default = "nginx" }
variable "ecs_container_file" { default = "./container.json" }
