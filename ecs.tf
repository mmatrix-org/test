data "template_file" "testapp" {
  template = file("./templates/image/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "test-def" {
  family                   = "mpulse-backend-sqa"
  execution_role_arn       = "arn:aws:iam::933085737869:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.testapp.rendered
}

resource "aws_ecs_service" "test-service" {
  name            = "mpulse-backend-sqa-green-service"
  cluster         = "sqa"
  task_definition = aws_ecs_task_definition.test-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = "prodcontainer"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.testapp]
}
