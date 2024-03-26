module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-let-code-speak-for-itself"
  cidr = var.cidr_block

  azs                    = var.availability_zones
  private_subnets        = var.private_subnets
  private_subnet_suffix  = "app"
  public_subnets         = var.public_subnets
  public_subnet_suffix   = "lb"
  database_subnets       = var.database_subnets
  database_subnet_suffix = "db"

  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true
}

// Load balancer security group
module "lb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name            = "${var.env}-let-code-speak-for-itself-lb"
  use_name_prefix = false
  description     = "Security group for HTTPS traffic"
  vpc_id          = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http traffic from load balancer"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "https traffic from load balancer"
      cidr_blocks = "0.0.0.0/0"
      }, {
      from_port   = var.application_port
      to_port     = var.application_port
      protocol    = "tcp"
      description = "http traffic from load balancer"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

// Application security group
module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name            = "${var.env}-let-code-speak-for-itself-app"
  use_name_prefix = false
  description     = "Security group to application from load balancer"
  vpc_id          = module.vpc.vpc_id
  ingress_with_source_security_group_id = [
    {
      from_port                = var.application_port
      to_port                  = var.application_port
      protocol                 = "tcp"
      description              = "application traffic from load balancer"
      source_security_group_id = module.lb_sg.security_group_id
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "application traffic from load balancer"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

// Database security group
module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name            = "${var.env}-let-code-speak-for-itself-db"
  use_name_prefix = false
  description     = "Security group to postgresql from application"
  vpc_id          = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "postgresql from application"
      source_security_group_id = module.app_sg.security_group_id
    },
  ]
  egress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "postgresql from application"
      source_security_group_id = module.app_sg.security_group_id
    },
  ]
}
