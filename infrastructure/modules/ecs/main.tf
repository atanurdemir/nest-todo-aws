resource "aws_ecs_cluster" "nest-ecs-cluster" {
  name = "nest-ecs-cluster-${var.environment}"
  tags = {
    Name        = "NestJS ECS Cluster"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "nest-backend-ecr" {
  name                 = "backend-services"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name        = "Backend Services ECR Repository"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "backend-task-definition" {
  family                   = "BackendTaskDefinition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "backend-services"
      image     = "${var.image}"
      cpu       = "${tonumber(var.container_cpu)}"
      memory    = "${tonumber(var.container_memory)}"
      essential = true
      environment = [
        { "name" : "NODE_ENV", "value" : "${var.environment}" },
        { "name" : "ENV", "value" : "${var.environment}" },
      ],
      ulimits = [
        {
          name      = "nofile",
          softLimit = 64000,
          hardLimit = 64000
        }
      ]
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 3000
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/nest-${var.environment}"
          awslogs-region        = "eu-west-1"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "ecs"
        }
      },
    },
  ])
  volume {
    name = "appvol"
  }
  tags = {
    Name        = "Backend Services ECS Task Definition"
    Project     = "NestJS"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "backend-service" {
  name            = "nest-backend-service"
  cluster         = aws_ecs_cluster.nest-ecs-cluster.id
  task_definition = aws_ecs_task_definition.backend-task-definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    container_name   = "backend-services"
    target_group_arn = var.target_group_arn
    container_port   = 3000

  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = var.security_groups

  }
}