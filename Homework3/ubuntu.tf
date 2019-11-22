

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

#####################################
# network
####################################

module "network" {
  source = "./modules/aws-network"
  cluster_name_sg = "OpsSchool-sg"
}
#####################################
# servers
####################################

module "server-cluster" {
  source = "./modules/server-cluster"

  key_name = aws_key_pair.generated_key.key_name
  private_key = tls_private_key.class1_key.private_key_pem
  vpc_security_group_ids = module.network.aws_ssh_id
  cluster_name = "OpsSchool"
  aws_availability_zone = var.aws_availability_zone
  index_path = var.index_path

}
