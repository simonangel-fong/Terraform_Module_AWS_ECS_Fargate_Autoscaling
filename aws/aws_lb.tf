# ##############################
# ALB SG
# ##############################
resource "aws_security_group" "lb_sg" {
  name        = "${var.project}-lb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-lb-sg"
  }
}

# ##############################
# ALB
# ##############################
resource "aws_alb" "lb" {
  name               = "${var.project}-lb"
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.subnets : subnet.id]
  security_groups    = [aws_security_group.lb_sg.id]
}

# ##############################
# ALB Target Group
# ##############################
resource "aws_alb_target_group" "lb_tg" {
  name        = "${var.project}-lb-tg"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  protocol    = "HTTP"

  health_check {
    path                = "/"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "15"
    matcher             = "200"
    timeout             = "3"
  }
}

# ##############################
# ALB listener
# ##############################
# Route traffic from the ALB to the target group
resource "aws_alb_listener" "lb_lsn" {
  load_balancer_arn = aws_alb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.lb_tg.arn
    type             = "forward"
  }
}
