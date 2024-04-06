# main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "web_cluster" {
  name = "web-cluster"
}

resource "aws_ecs_task_definition" "web_task" {
  family                   = "web-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "web-container"
      image     = "your-docker-image-repo:latest"
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web_cluster.id
  task_definition = aws_ecs_task_definition.web_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-xxxxxxxxxx"]
    security_groups  = ["sg-xxxxxxxxxx"]
    assign_public_ip = true
  }
}
