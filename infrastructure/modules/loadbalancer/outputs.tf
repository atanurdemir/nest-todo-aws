output "backend_target_group_arn" {
  value = aws_lb_target_group.nest-backend-tg.arn
}

output "backend_lb_listener" {
  value = aws_lb_listener.nest-backend-listener
}

output "backend_lb" {
  value = aws_lb.nest-backend-lb
}