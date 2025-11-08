resource "aws_security_group" "lb_sg" {
  name   = "${var.project}-lb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.ecs_port
    to_port     = var.ecs_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-lb-sg"
  }
}

resource "aws_alb" "lb" {
  name            = "${var.project}-lb"
  subnets         = [for subnet in aws_subnet.subnets : subnet.id]
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_alb_target_group" "lb_tg" {
  name        = "${var.project}-lb-tg"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
  protocol    = var.ecs_protocol
  port        = var.ecs_port

  health_check {
    protocol            = var.ecs_protocol
    path                = var.lb_health_check_path
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
  port              = var.ecs_port
  protocol          = var.ecs_protocol

  default_action {
    target_group_arn = aws_alb_target_group.lb_tg.id
    type             = "forward"
  }
}
