resource "aws_security_group" "lb_sg" {
  name        = var.lb_sg_name
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.ecs_con_port
    to_port     = var.ecs_con_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "lb" {
  name = var.lb_name
  # subnets         = aws_subnet.subnet.*.id
  subnets         = [for subnet in aws_subnet.subnets : subnet.id]
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_alb_target_group" "lb_tg" {
  name        = var.lb_tg_name
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
  protocol    = var.lb_tg_protocol
  port        = var.lb_tg_port

  health_check {
    protocol            = var.lb_tg_protocol
    path                = var.lb_tg_health_check
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    timeout             = "3"
  }
}

# Route traffic from the ALB to the target group
resource "aws_alb_listener" "lb_lsn" {
  load_balancer_arn = aws_alb.lb.id
  port              = var.lb_tg_port
  protocol          = var.lb_tg_protocol

  default_action {
    target_group_arn = aws_alb_target_group.lb_tg.id
    type             = "forward"
  }
}
