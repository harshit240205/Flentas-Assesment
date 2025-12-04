Overview:
This Terraform configuration implements a highly available, auto-scaling web application architecture on AWS with Application Load Balancer, Auto Scaling Group, and multi-AZ deployment.

Approach:
- I designed a production-ready architecture focused on high availability and fault tolerance.
- The Application Load Balancer sits in public subnets to accept internet traffic, while EC2 instances run in private subnets for security.
- The Auto Scaling Group automatically maintains 2 instances across two availability zones, replacing any unhealthy instances.
- Traffic flows from users through the internet-facing ALB, which distributes requests to healthy backend instances using round-robin load balancing.
- This architecture survives individual instance failures and entire availability zone outages, ensuring continuous service availability with automatic self-healing capabilities.





