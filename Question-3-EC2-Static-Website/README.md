Overview:
This Terraform configuration implements a production-ready, highly available web application infrastructure on AWS with Application Load Balancer, Auto Scaling Group, and multi-AZ deployment for fault tolerance and automatic scaling.

Approach:
I designed a production-ready architecture focused on high availability and fault tolerance. 
- The Application Load Balancer sits in public subnets across two availability zones to accept internet traffic, while EC2 instances run in private subnets for enhanced security.
- The Auto Scaling Group automatically maintains 2 instances distributed across both availability zones, replacing any unhealthy instances within minutes.
- Traffic flows from users through the internet-facing ALB, which performs healing capabilities and the ability to scale from 2 to 4 instances based on demand.
