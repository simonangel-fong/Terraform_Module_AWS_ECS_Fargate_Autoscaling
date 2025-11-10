resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/aws/ecs/${var.project}"
  retention_in_days = 7

  tags = {
    Name = "${var.project}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "${var.project}-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}
