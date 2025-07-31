# load balancer main definition
resource "aws_lb" "main_load_balancer" {
  name                       = "${var.prefix}-app"
  internal                   = false
  load_balancer_type         = var.load_balancer_type
  security_groups            = [aws_security_group.load_balancer_security_group.id]
  enable_deletion_protection = false

  subnets = var.public_subnet_ids
}

# target group
resource "aws_lb_target_group" "load_balancer_target_group" {
  name        = "app-target-group"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  port        = 80

  health_check {
    path = "/fizzbuzz/5"
    protocol = "HTTP"
    matcher  = "200"
    interval = 30
    timeout  = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http_load_balancer_listener" {
  load_balancer_arn = aws_lb.main_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  }
}
