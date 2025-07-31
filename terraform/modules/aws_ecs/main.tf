data "aws_region" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "${var.prefix}-${var.app_name}-cluster"
}

resource "aws_ecs_service" "app" {
  name             = "${var.prefix}-${var.app_name}"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.app_task.family
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_service_security_group.id]
  }

  load_balancer {
    target_group_arn = var.elb_target_group_arn
    container_name   = "${var.prefix}-${var.app_name}"
    container_port   = 8000
  }
}

# CloudWatch Log Group for ECS Task Logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name_prefix       = "/ecs/my-app-"
  retention_in_days = 7

  tags = {
    Name = "ecs-app-logs"
  }
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.prefix}-${var.app_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.prefix}-${var.app_name}"
      image = "${var.ecr_image_url}:latest"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000      # In awsvpc network mode, hostPort is not really used but required
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = "production"
        }
        # Add other environment variables as needed
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs-app"
        }
      }
    }
  ])

  tags = {
    Name = "${var.prefix}-${var.app_name}"
  }
}
