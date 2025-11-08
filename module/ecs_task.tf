# data "template_file" "cb_app" {
#     template = file("./example.json.tpl")

#     vars = {
#         con_name      = var.ecs_con_name
#         app_port       = var.app_port
#         fargate_cpu    = var.fargate_cpu
#         fargate_memory = var.fargate_memory
#         aws_region     = var.aws_region
#     }
# }

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = var.ecs_task_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_fargate_cpu
  memory                   = var.ecs_fargate_memory
  #   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# resource "aws_ecs_service" "ecs_service" {
#     name            = var.ecs_service_name
#     cluster         = aws_ecs_cluster.ecs_cluster.id
#     launch_type     = "FARGATE"

#     # task
#     task_definition = aws_ecs_task_definition.ecs_task_def.arn
#     desired_count   = var.ecs_service_desired_count

#     network_configuration {
#         security_groups  = [aws_security_group.ecs_tasks.id]
#         subnets          = aws_subnet.subnets.*.id
#         assign_public_ip = true
#     }

#     # load_balancer {
#     #     target_group_arn = aws_alb_target_group.app.id
#     #     container_name   = var.ecs_con_name
#     #     container_port   = var.ecs_con_port
#     # }

#     # depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
# }