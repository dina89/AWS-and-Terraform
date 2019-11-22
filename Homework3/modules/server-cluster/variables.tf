variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "key_name" {
  description = "The key"
  type        = string
}

variable "private_key" {
  description = "The private"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The vpc security group id's"
  type        = string
}

variable "aws_availability_zone" {
  description = "availability zone"
  type        = string
}

variable "index_path" {
  description = "path to index.html"
  type        = string
}