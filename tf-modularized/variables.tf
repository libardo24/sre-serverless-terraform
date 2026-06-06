variable "aws_region" {
  type = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "project_name" {
  type = string
  default     = "sre-prueba-tecnica"
  description = "Project name"
}

variable "vpc_cidr" {
  type = string
  default     = "10.20.0.0/16"
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24"]
  description = "List of private subnet CIDR blocks"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "lambda_timeout" {
  type    = number
  default = 30
  description = "Lambda function timeout in seconds"
}

variable "lambda_memory_size" {
  type    = number
  default = 256
}

variable "throttle_burst_limit" {
  type    = number
  default = 100
}

variable "throttle_rate_limit" {
  type    = number
  default = 50
}

variable "cache_ttl" {
  type    = string
  default = "60"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "s3_force_destroy" {
  type    = bool
  default = true
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}
