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
# ECS
# ##############################
variable "ecs_name" { type = string }
