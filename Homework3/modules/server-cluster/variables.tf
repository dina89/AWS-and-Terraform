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
  type        = list(string)
}

# variable "aws_availability_zone" {
#   description = "availability zone"
#   type        = list(string)
# }

variable "public_subnet_id" {
  description = "the subnet id"
  type        = list(string)
}

variable "private_subnet_id" {
  description = "the subnet id"
  type        = list(string)
}

variable "index_path" {
  description = "path to index.html"
  type        = string
}

variable "iam_instance_profile" {
  description = "profile to access s3"
  type        = string
}
