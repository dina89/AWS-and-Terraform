#####################################
# variables
####################################

# variable "aws_access_key" {}
# variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-east-1"
}

variable "availability_zones" {
  description = "AZs in this region to use"
  default = ["us-east-1a", "us-east-1c"]
  type = "list"
}

variable "key_name" {
    default = "OpsSchool"
}

variable "index_path" {
    default = "Index.html"
}

variable "instanceTenancy" {
 default = "default"
}
variable "dnsSupport" {
 default = true
}
variable "dnsHostNames" {
        default = true
}
variable "vpcCIDRblock" {
 default = "10.0.0.0/16"
}
variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default = ["10.0.10.0/24", "10.0.20.0/24"]
  type = "list"
}
variable "subnet_cidrs_private" {
  description = "Subnet CIDRs for private subnets (length must match configured availability_zones)"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type = "list"
}
variable "destinationCIDRblock" {
        default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
        type = "list"
        default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
        default = true
}
