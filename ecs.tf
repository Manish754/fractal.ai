resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  container_definitions    = file("${path.module}/ecs-params.json")
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [module.vpc.default_security_group_id]
    assign_public_ip = true
  }
}
