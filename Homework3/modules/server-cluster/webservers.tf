#####################################
# resources
####################################

#Create the instances "public_server"
resource "aws_instance" "public_server" {
  count = 2
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.medium"
  #availability_zone = element(var.aws_availability_zone, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = element(var.public_subnet_id, count.index)
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = var.private_key
  }

  provisioner "file" {
    source      = var.index_path
    destination = "/tmp/index.html"
  }

    provisioner "file" {
    source      = "log2s3.sh"
    destination = "/tmp/log2s3.sh"
  }
  
  provisioner "remote-exec"{
      inline = [
          "sudo apt-get -y update",
          "sudo apt-get -y install nginx",
          "sudo service nginx start",
          "sudo cat /etc/hostname >> /tmp/index.html",
          "sudo mv -f /tmp/index.html /var/www/html/",
          "sudo apt-get install unzip",
          "curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
          "unzip awscliv2.zip",
          "sudo ./aws/install",
          "chmod +x /tmp/log2s3.sh",
          "sudo echo \"$(echo \"30 * * * * /tmp/log2s3.sh >> /tmp/log2s3.log 2>&1 \" ; crontab -l)\" | crontab -"
      ]
  }

    tags = {
    Owner = "Dina Stefansky"
    Name = "public Server[count.index]"
    Purpose = "Learning"
  }
}

resource "aws_instance" "private_server" {
  count = 2
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.medium"
  #availability_zone = element(var.aws_availability_zone, count.index)
  key_name               = var.key_name
  subnet_id = element(var.private_subnet_id, count.index)

  tags = {
    Name = "private Server[count.index]"
  }
}

output "aws_instance_public_dns" {
       value = aws_instance.public_server.*.public_ip
}

output "aws_instance_private_dns" {
       value = aws_instance.private_server.*.public_ip
}

output "aws_instance_public_id" {
       value = aws_instance.public_server.*.id
}

output "aws_instance_private_id" {
       value = aws_instance.public_server.*.id
}
