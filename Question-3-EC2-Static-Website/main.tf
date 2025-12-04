# Configure AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================================
# NETWORKING
# ========================================

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}_igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}_public_subnet"
    Type = "Public"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.prefix}_public_rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ========================================
# SECURITY GROUP
# ========================================

# Security Group for Web Server
resource "aws_security_group" "web_server" {
  name        = "${var.prefix}_web_server_sg"
  description = "Security group for web server - HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from your IP only (SECURITY HARDENING)
  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}_web_server_sg"
  }
}

# ========================================
# EC2 INSTANCE
# ========================================

# EC2 Instance for Web Server
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web_server.id]

  # SECURITY HARDENING: Enforce IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # Enforce IMDSv2
    http_put_response_hop_limit = 1
  }

  # SECURITY HARDENING: Encrypted root volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  # User data to install and configure Nginx
  user_data = <<-EOF
              #!/bin/bash
              # Update system (SECURITY HARDENING)
              yum update -y
              
              # Install Nginx
              amazon-linux-extras install nginx1 -y
              
              # Start and enable Nginx
              systemctl start nginx
              systemctl enable nginx
              
              # Copy resume HTML
              cat > /usr/share/nginx/html/index.html << 'HTML'
              ${file("${path.module}/resume.html")}
              HTML
              
              # Set proper permissions
              chmod 644 /usr/share/nginx/html/index.html
              chown nginx:nginx /usr/share/nginx/html/index.html
              
              # Restart Nginx to apply changes
              systemctl restart nginx
              
              echo "Web server setup completed!"
              EOF

  tags = {
    Name = "${var.prefix}_web_server"
  }
}

# Elastic IP for the instance (optional but recommended)
resource "aws_eip" "web_server" {
  domain   = "vpc"
  instance = aws_instance.web_server.id

  tags = {
    Name = "${var.prefix}_web_server_eip"
  }

  depends_on = [aws_internet_gateway.main]
}