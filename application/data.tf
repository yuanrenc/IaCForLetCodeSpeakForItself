data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-let-code-speak-for-itself"
  }
}

data "aws_security_group" "app_sg" {
  name = "${var.env}-let-code-speak-for-itself-app"
}

data "aws_subnets" "app" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
   filter {
     name = "tag:Name"
    values = [
      "${var.env}-let-code-speak-for-itself-app-ap-southeast-2a",
      "${var.env}-let-code-speak-for-itself-app-ap-southeast-2b",
      "${var.env}-let-code-speak-for-itself-app-ap-southeast-2c",
    ]
  }
}

data "aws_subnets" "lb" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
    filter {
    name = "tag:Name"
    values = [
      "${var.env}-let-code-speak-for-itself-lb-ap-southeast-2a",
      "${var.env}-let-code-speak-for-itself-lb-ap-southeast-2b",
      "${var.env}-let-code-speak-for-itself-lb-ap-southeast-2c",
    ]
  }
}

// Load Balancer security group
data "aws_security_group" "lb_sg" {
  name = "${var.env}-let-code-speak-for-itself-lb"
}

data "aws_db_instance" "db" {
  db_instance_identifier = "${var.env}app"
}