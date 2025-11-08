output "lb_dns" {
  value = "${aws_alb.lb.dns_name}:${var.ecs_port}"
}
