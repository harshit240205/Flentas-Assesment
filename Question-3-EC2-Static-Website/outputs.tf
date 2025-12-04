output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP address of the web server"
  value       = aws_eip.web_server.public_ip
}

output "website_url" {
  description = "URL to access the website"
  value       = "http://${aws_eip.web_server.public_ip}"
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_server.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_eip.web_server.public_ip}"
}