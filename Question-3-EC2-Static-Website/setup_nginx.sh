#!/bin/bash


sudo yum update -y


sudo amazon-linux-extras install nginx1 -y


sudo systemctl start nginx
sudo systemctl enable nginx

if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --reload
fi


sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup


sudo rm -f /usr/share/nginx/html/index.html


echo "Nginx installation and configuration completed successfully!"
