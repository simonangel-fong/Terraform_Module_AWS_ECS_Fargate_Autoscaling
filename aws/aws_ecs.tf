# #################################
# ECS: Cluster
# #################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-ecs-cluster"
}

###############################################
# Task IAM Roles: ECS Task Execution
###############################################
# assume policy
data "aws_iam_policy_document" "task_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# assume role
resource "aws_iam_role" "task_assume_role" {
  name               = "${var.project}-task-assume-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_policy.json
}

# attach policy
resource "aws_iam_role_policy_attachment" "task_assume_role_attach" {
  role       = aws_iam_role.task_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# #################################
# Task: SG
# #################################
resource "aws_security_group" "ecs_task_sg" {
  name        = "${var.project}-task-sg"
  description = "ECS tasks security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "from ALB"
    from_port       = 80 # ALB port
    to_port         = 80 # container port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# #################################
# ECS: Task Definition
# #################################
resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.project}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_assume_role.arn # assign executiong role

  container_definitions = file("./task.json")
}

# #################################
# ECS: Service
# #################################
resource "aws_ecs_service" "ecs_service" {
  name    = "${var.project}-svc"
  cluster = aws_ecs_cluster.ecs_cluster.id

  # task
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.ecs_task_def.arn
  desired_count    = 1

  # network
  network_configuration {
    security_groups  = [aws_security_group.ecs_task_sg.id]
    subnets          = [for subnet in aws_subnet.subnets : subnet.id]
    assign_public_ip = true
  }

  # lb
  load_balancer {
    target_group_arn = aws_alb_target_group.lb_tg.id
    container_name   = "fastapi"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.lb_lsn]
}

# #################################
# Service: Scaling policy
# #################################
resource "aws_appautoscaling_target" "scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "scaling_cpu" {
  name               = "${var.project}-scale-cpu"
  resource_id        = aws_appautoscaling_target.scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 60 # cpu%
    scale_in_cooldown  = 30
    scale_out_cooldown = 30
  }
}

resource "aws_appautoscaling_policy" "scaling_memory" {
  name               = "${var.project}-scale-memory"
  resource_id        = aws_appautoscaling_target.scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.scaling_target.service_namespace
  policy_type        = "PredictiveScaling"

  predictive_scaling_policy_configuration {
    metric_specification {
      target_value = 40  # memory %

      predefined_metric_pair_specification {
        predefined_metric_type = "ECSServiceMemoryUtilization"
      }
    }
  }
}