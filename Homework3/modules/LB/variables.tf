variable "security_groups" {
  description = "The sg for the LB"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets to Load Balance"
  type        = list(string)
}

variable "s3_logs_bucket" {
  description = "The S3 bucket for the logging"
  type        = string
}

variable "vpc_id" {
  description = "The vpc id"
  type        = string
}

variable "server_id" {
  description = "The server ids"
  type        = list(string)
}

