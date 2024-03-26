# Network config
cidr_block = "10.14.0.0/16"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
private_subnets    = ["10.14.2.0/28", "10.14.4.0/28", "10.14.6.0/28"]
public_subnets     = ["10.14.1.0/28", "10.14.3.0/28", "10.14.5.0/28"]
database_subnets   = ["10.14.10.0/28", "10.14.11.0/28", "10.14.12.0/28"]
enable_nat_gateway = true

# Database config
db_version  = "16.2"
db_instance = "db.t3.micro"

# Application config
# See "Task CPU and memory" at https://docs.aws.amazon.com/AmazonECS/latest/userguide/fargate-task-defs.html 
# for more details
cpu    = "256"
memory = "2048"
