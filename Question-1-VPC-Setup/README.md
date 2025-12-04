Overview:
This Terraform configuration creates a complete VPC infrastructure on AWS with public and private subnets across two availability zones, following AWS best practices for high availability and security.


Approach: 
- I created a VPC setup with proper network separation to keep everything secure and well-organized.
- The VPC is spread across multiple availability zones so the system keeps running even if one zone goes down.
- Public subnets contain resources that need internet access, such as the NAT Gateway.
- Private subnets contain internal backend services that shouldn’t be exposed to the internet.
- An Internet Gateway allows internet access for resources in public subnets.
- The NAT Gateway (placed in the publpublic subnet) lets private subnet resources access the internet safely without allowing any incoming traffic from outside.
- Route tables are set so that public subnets send traffic through the Internet Gateway, and private subnets send their traffic through the NAT Gateway.
