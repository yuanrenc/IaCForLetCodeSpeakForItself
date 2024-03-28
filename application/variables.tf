variable "env" {
  type        = string
  description = "name of the environment"
}

variable "deploy_version" {
  type        = string
  default     = "latest"
  description = "version of the application to image to deploy"
}

variable "application_port" {
  type        = number
  default     = 4444
  description = "port of the running application"
}

variable "cpu" {
  type        = number
  description = "vCPU units to assign the container"
}

variable "memory" {
  type        = number
  description = "memory in MB to assign the container"
}