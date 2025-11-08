# resource "aws_security_group" "ecs_task_sg" {
#     name        = "cb-ecs-tasks-security-group"
#     description = "allow inbound access from the ALB only"
#     vpc_id      = aws_vpc.main.id

#     ingress {
#         protocol        = "tcp"
#         from_port       = var.ecs_con_port
#         to_port         = var.ecs_con_port
#         security_groups = [aws_security_group.lb.id]
#     }

#     egress {
#         protocol    = "-1"
#         from_port   = 0
#         to_port     = 0
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.ecs_name}"
}