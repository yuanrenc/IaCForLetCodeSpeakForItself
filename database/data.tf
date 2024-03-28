data "aws_security_group" "db_sg" {
  name = "${var.env}-let-code-speak-for-itself-db"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.env}-let-code-speak-for-itself"
  }
}

data "aws_subnets" "db" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name = "tag:Name"
    values = [
      "${var.env}-let-code-speak-for-itself-db-ap-southeast-2a",
      "${var.env}-let-code-speak-for-itself-db-ap-southeast-2b",
      "${var.env}-let-code-speak-for-itself-db-ap-southeast-2c",
    ]
  }
}
