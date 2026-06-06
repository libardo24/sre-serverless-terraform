variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "lambda_role_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}