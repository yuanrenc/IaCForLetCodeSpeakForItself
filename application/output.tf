output "endpoint" {
  value = "http://${aws_lb.app.dns_name}"
}