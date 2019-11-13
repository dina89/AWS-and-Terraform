
#####################################
# variables
####################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-east-1"
}

variable "aws_availability_zone" {
    default = "us-east-1d"
}

variable "key_name" {
    default = "OpsSchool"
}


variable "index_path" {
    default = "Index.html"
}
#####################################
# providors
####################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

#####################################
# resources
####################################

resource "aws_default_vpc" "default"{

}

resource "tls_private_key" "class1_key"{
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key"{
  key_name = var.key_name
  public_key = tls_private_key.class1_key.public_key_openssh
}

resource "aws_security_group" "allow_ssh"{
    name = "nginx_demo"
    description = "Open ports for nginx demo"
    vpc_id = aws_default_vpc.default.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_ebs_volume" "disk2" {
  count             = 2
  availability_zone = var.aws_availability_zone
  size              = 10
  encrypted         = true
  type              = "gp2"
}

resource "aws_volume_attachment" "ebs_att" {
  count       = 2
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.disk2[count.index].id
  instance_id = aws_instance.OpsSchool[count.index].id
}

resource "aws_instance" "OpsSchool" {
  count                  = 2
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = tls_private_key.class1_key.private_key_pem
  }

  provisioner "file" {
    source      = var.index_path
    destination = "/tmp/index.html"
  }
  
  provisioner "remote-exec"{
      inline = [
          "sudo apt-get -y update",
          "sudo apt-get -y install nginx",
          "sudo service nginx start",
          "sudo mv -f /tmp/index.html /var/www/html/"
      ]
  }

    tags = {
    Owner = "Dina Stefansky"
    Name = "OpsSchool Server [count.index]"
    Purpose = "Learning"
  }
}

#####################################
# output
####################################

#output "aws_instance1_public_dns" {
    #value = [aws_instance.OpsSchool1.public_dns]
#}

#output "aws_instance2_public_dns" {
 #   value = [aws_instance.OpsSchool2.public_dns]
#}
