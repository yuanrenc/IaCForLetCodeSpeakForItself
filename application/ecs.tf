data "template_file" "app" {
  template = file("./app.json.tpl")
  vars = {
    image          = "colinwang847/letcodespeakforitself"
    db_endpoint    = split(":", data.aws_db_instance.db.endpoint)[0]
    deploy_version = var.deploy_version
    env            = var.env
    port           = var.application_port
    db_password    = "${trimspace(file("../database/password.txt"))}"
    log_group      = aws_cloudwatch_log_group.app.name
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name = "applicationLogs"
}

resource "aws_ecs_cluster" "app" {
  name = "${var.env}-let-code-speak-for-itself"

}

resource "aws_ecs_cluster_capacity_providers" "app" {
  cluster_name = aws_ecs_cluster.app.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.env}-let-code-speak-for-itself-app"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.app.rendered
  tags = {
    env  = var.env
    Name = "${var.env}-let-code-speak-for-itself"
  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.env}-let-code-speak-for-itself-app"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [data.aws_security_group.app_sg.id]
    subnets          = data.aws_subnets.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "App"
    container_port   = var.application_port
  }

  depends_on = [aws_lb_listener.http_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    env  = var.env
    Name = "${var.env}-let-code-speak-for-itself-app"
  }
}
