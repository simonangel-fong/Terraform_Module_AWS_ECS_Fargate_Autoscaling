# resource "aws_appautoscaling_target" "ecs_target" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   max_capacity       = 4
#   min_capacity       = 1
# }

# resource "aws_appautoscaling_policy" "scale_up" {
#   name               = "${var.project}-scale-up"
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }
#   }

#   depends_on = [aws_appautoscaling_target.ecs_target]
# }

# resource "aws_appautoscaling_policy" "scale_down" {
#   name               = "${var.project}-scale-down"
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = -1
#     }
#   }

#   depends_on = [aws_appautoscaling_target.ecs_target]
# }
