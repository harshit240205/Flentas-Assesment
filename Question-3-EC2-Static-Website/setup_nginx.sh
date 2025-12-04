#!/bin/bash

# Update system packages
sudo yum update -y

# Install Nginx
sudo amazon-linux-extras install nginx1 -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure firewall (if firewalld is installed)
if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --reload
fi

# Create backup of default nginx config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Remove default welcome page
sudo rm -f /usr/share/nginx/html/index.html

# Copy resume HTML (will be provided via Terraform)
# The actual HTML will be written by Terraform's file provisioner

echo "Nginx installation and configuration completed successfully!"