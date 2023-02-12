resource "aws_lb" "nest-backend-lb" {
  name               = "backend-load-balancer-${var.environment}"
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  tags               = {}
}

resource "aws_lb_target_group" "nest-backend-tg" {
  name                 = "backend-lb-target-${var.environment}"
  port                 = 443
  protocol             = "TCP"
  target_type          = "ip"
  deregistration_delay = 10
  health_check {
    enabled             = true
    interval            = 10
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }
  vpc_id = var.vpc_id
  tags   = {}
}

resource "aws_lb_listener" "nest-backend-listener" {
  load_balancer_arn = aws_lb.nest-backend-lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nest-backend-tg.arn
  }
}