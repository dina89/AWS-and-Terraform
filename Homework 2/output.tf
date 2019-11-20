output "ansible_server_public_address" {
    value = aws_instance.public_server.*.public_ip
}
output "ansible_server_private_address" {
    value = aws_instance.private_server.*.private_ip
}
