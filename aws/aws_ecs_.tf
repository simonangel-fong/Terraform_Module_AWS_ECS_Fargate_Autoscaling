# # #################################
# # ECS: Capacity Provider
# # #################################
# resource "aws_ecs_cluster_capacity_providers" "ecs_cap" {
#   cluster_name       = aws_ecs_cluster.ecs_cluster.name
#   capacity_providers = ["FARGATE", "FARGATE_SPOT"]

#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE"
#     base              = 1 # keep at least 1 on on-demand
#     weight            = 1
#   }

#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     weight            = 3 # ~75% of the remainder goes to spot
#   }
# }




# resource "aws_cloudwatch_metric_alarm" "high_cpu" {
#   alarm_name          = "${var.project}-high-cpu-alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = 60
#   statistic           = "Average"
#   threshold           = 80
#   dimensions = {
#     ClusterName = aws_ecs_cluster.ecs_cluster.name
#     ServiceName = aws_ecs_service.ecs_service.name
#   }
#   alarm_description = "The alarm monitors ECS service CPU utilization."
# }

# resource "aws_cloudwatch_metric_alarm" "low_memory" {
#   alarm_name          = "${var.project}-low-memory-alarm"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "MemoryUtilization"
#   namespace           = "AWS/ECS"
#   period              = 60
#   statistic           = "Average"
#   threshold           = 20
#   dimensions = {
#     ClusterName = aws_ecs_cluster.ecs_cluster.name
#     ServiceName = aws_ecs_service.ecs_service.name
#   }
#   alarm_description = "The alarm monitors ECS service memory utilization."
# }
