variable "project_name" { type = string }
variable "lambda_invoke_arn" { type = string }
variable "lambda_function_name" { type = string }
variable "access_log_destination_arn" { type = string }
variable "throttle_burst_limit" { type = number }
variable "throttle_rate_limit" { type = number }
variable "cors_allow_origins" { type = list(string) }
variable "tags" { type = map(string) }
