output "ec2_public_ip" {
  value = aws_instance.wp_server.public_ip
}
