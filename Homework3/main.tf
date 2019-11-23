

#####################################
# providors
####################################

provider "aws" {
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "tls_private_key" "class1_key"{
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key"{
  key_name = var.key_name
  public_key = tls_private_key.class1_key.public_key_openssh
}


####################################
# vpc
####################################

module "vpc" {
  source = "./modules/VPC"
  aws_region = var.aws_region
  vpcCIDRblock = var.vpcCIDRblock
  instanceTenancy = var.instanceTenancy
  dnsSupport = var.dnsSupport
  dnsHostNames = var.dnsHostNames
  subnet_cidrs_public = var.subnet_cidrs_public
  subnet_cidrs_private = var.subnet_cidrs_private
  availability_zones = var.availability_zones
  destinationCIDRblock = var.destinationCIDRblock
  ingressCIDRblock = var.ingressCIDRblock
  mapPublicIP = var.mapPublicIP
}

#####################################
# security
####################################

module "security" {
  source = "./modules/aws-security"
  cluster_name_sg = "OpsSchool-sg"
  vpc_id = module.vpc.vpc_id
}

#####################################
# servers
####################################

module "server-cluster" {
  source = "./modules/server-cluster"

  key_name = aws_key_pair.generated_key.key_name
  private_key = tls_private_key.class1_key.private_key_pem
  vpc_security_group_ids = module.security.aws_ssh_id
  cluster_name = "OpsSchool"
  #aws_availability_zone = var.aws_availability_zone
  index_path = var.index_path
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id

}

#####################################
# lb
####################################

module "LB" {
  source = "./modules/LB"

  public_subnets = module.vpc.public_subnet_id
  s3_logs_bucket = "opsschool-dina-state-storage-s3"
  security_groups = module.security.aws_ssh_id
  vpc_id = module.vpc.vpc_id
  server_id = module.server-cluster.aws_instance_public_id
}