#####################################
# resources
####################################

#Create an 2 extra disks "disk2"
resource "aws_ebs_volume" "disk2" {
  count             = 2
  availability_zone = var.aws_availability_zone
  size              = 10
  encrypted         = true
  type              = "gp2"
}

#Create an disk attachment to the instances
resource "aws_volume_attachment" "ebs_att" {
  count       = 2
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.disk2[count.index].id
  instance_id = aws_instance.OpsSchool[count.index].id
}

#Create the instances "OpsSchool"
resource "aws_instance" "OpsSchool" {
  count                  = 2
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_ids]
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

output "aws_instance_public_dns" {
       value = aws_instance.OpsSchool.*.public_ip
}