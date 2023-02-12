resource "aws_iam_role" "ecs-task-role" {
  name = "ECSTaskRole"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name        = "ECS Task Role"
    Environment = var.environment
  }
}

resource "aws_iam_role" "ecs-execution-role" {
  name = "ECSTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  path = "/"
  inline_policy {
    name = "root"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken",
            "firehose:PutRecordBatch",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "logs:*",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:logs:*:${var.account_id}:log-group:*",
            "arn:aws:logs:*:${var.account_id}:log-group:*:log-stream:*",
          ]
        },
      ]
    })
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  tags = {
    Name        = "ECS Task Execution Role"
    Environment = var.environment
  }
}