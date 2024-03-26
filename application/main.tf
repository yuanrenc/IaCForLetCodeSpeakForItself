resource "aws_lb" "app" {
  name               = "${var.env}-code-speak-app"
  subnets            = data.aws_subnets.lb.ids
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb_sg.id]

  tags = {
    env  = var.env
    Name = "${var.env}-code-speak-app"
  }
}

# Send traffic to application
resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.env}-code-speak-app"
  port        = var.application_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "20"
    path                = "/healthcheck/"
    unhealthy_threshold = "2"
  }
}