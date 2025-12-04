variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "Harshit-Parmar"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
  default     = "Harshit_Parmar_key"
}

variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
  default     = "0.0.0.0/0"
  
}
