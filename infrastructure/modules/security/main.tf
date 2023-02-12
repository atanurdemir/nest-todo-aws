resource "aws_security_group" "ecs-security-group" {
  name        = "ECS Service SG"
  description = "Security Group for ECS Service"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All Outbound Access Rule"
  }

  ingress {
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
    cidr_blocks = [var.cidr_blocks]
    description = "All Inbound Access Rule"
  }

  tags = {
    Name        = "Security Group for ECS Service"
    Project     = "NestJS TODO"
    Environment = var.environment
  }
}