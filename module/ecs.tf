# #################################
# ECS: SG
# #################################
resource "aws_security_group" "ecs_task_sg" {
  name   = "${var.project}-task-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.ecs_port
    to_port         = var.ecs_port
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# #################################
# ECS: Cluster
# #################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-ecs-cluster"
}

# #################################
# ECS: Capacity Provider
# #################################
resource "aws_ecs_cluster_capacity_providers" "ecs_cap" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1 # keep at least 1 on on-demand
    weight            = 1
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 3 # ~75% of the remainder goes to spot
  }
}

# #################################
# ECS: Task Definition
# #################################
resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.project}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = file(var.ecs_container_file)

  # container_definitions = jsonencode([
  #   {
  #     name      = "nginx"
  #     image     = "nginx"
  #     cpu       = 10
  #     memory    = 512
  #     essential = true
  #     portMappings = [
  #       {
  #         containerPort = 80
  #         hostPort      = 80
  #       }
  #     ]
  #   }
  # ])
}

# #################################
# ECS: Service
# #################################
resource "aws_ecs_service" "ecs_service" {
  name    = "${var.project}-service"
  cluster = aws_ecs_cluster.ecs_cluster.id

  # task
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = var.ecs_svc_desired

  network_configuration {
    security_groups  = [aws_security_group.ecs_task_sg.id]
    subnets          = [for subnet in aws_subnet.subnets : subnet.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.lb_tg.id
    container_name   = var.ecs_container_name
    container_port   = var.ecs_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [aws_alb_listener.lb_lsn]
}
