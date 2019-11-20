
provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

#get the aws ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "server_key" {
  key_name   = "server_key"
  public_key = tls_private_key.server_key.public_key_openssh
}

#Create the Security Group
resource "aws_security_group" "vpc-sg" {
 name        = "vpc-sg"
 description = "security group for VPC"
 vpc_id      = aws_vpc.My_VPC.id
ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
        Name = "My VPC Security Group"
  }
}

# create VPC Network access control list
resource "aws_network_acl" "My_VPC_Security_ACL" {
  vpc_id = aws_vpc.My_VPC.id
  subnet_ids = ["${aws_subnet.public.0.id}", "${aws_subnet.public.1.id}"]
# allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }
# allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
}

#create the 4 servers
resource "aws_instance" "public_server" {
  count = 2

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.vpc-sg.id]
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  key_name               = aws_key_pair.ansible_key.key_name


  connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = tls_private_key.ansible_key.private_key_pem
  }

  tags = {
    Name = "public Server[count.index]"
  }
}

resource "aws_instance" "private_server" {
  count = 2

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  key_name               = aws_key_pair.ansible_key.key_name



  tags = {
    Name = "private Server[count.index]"
  }
}

