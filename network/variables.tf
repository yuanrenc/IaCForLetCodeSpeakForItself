variable "env" {
  type        = string
  description = "name of the environment"
}

variable "cidr_block" {
  type        = string
  description = "the CIDR block range to use for VPC creation"
}

variable "availability_zones" {
  type        = list(string)
  description = "availability zones to create the subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "cidr blocks for creating the private subnets"
}

variable "database_subnets" {
  type        = list(string)
  description = "cidr blocks for creating the database subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "cidr blocks for creating the public subnets"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "enable use of NAT gateway"
}

variable "application_port" {
  type        = number
  default     = 4444
  description = "port of the running application"
}
