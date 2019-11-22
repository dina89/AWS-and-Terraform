#####################################
# variables
####################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-east-1"
}

variable "aws_availability_zone" {
    default = "us-east-1a"
}

variable "key_name" {
    default = "OpsSchool"
}


variable "index_path" {
    default = "Index.html"
}