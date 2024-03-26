resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.env}-let-code-speak-for-itself-db-subnet"
  subnet_ids = data.aws_subnets.db.ids

  tags = {
    Name = "${var.env}-let-code-speak-for-itself-db-subnet"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage          = 20 # gigabytes
  backup_retention_period    = 7  # in days
  db_subnet_group_name       = aws_db_subnet_group.db_subnet.name
  auto_minor_version_upgrade = true
  engine                     = "postgres"
  engine_version             = var.db_version
  identifier                 = "${var.env}app"
  instance_class             = var.db_instance
  multi_az                   = true
  db_name                    = "app"
  password                   = trimspace(file("${path.module}/password.txt"))
  port                       = 5432
  publicly_accessible        = false
  storage_encrypted          = true
  storage_type               = "gp2"
  username                   = "postgres"
  vpc_security_group_ids     = ["${data.aws_security_group.db_sg.id}"]
  skip_final_snapshot        = true

  tags = {
    Name = "${var.env}-let-code-speak-for-itself-db"
  }
}
