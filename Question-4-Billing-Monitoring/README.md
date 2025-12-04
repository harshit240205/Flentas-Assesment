Overview:

Implementation of AWS cost monitoring and billing alerts to prevent unexpected charges and track Free Tier usage.



\## Approach



I implemented AWS cost monitoring by enabling billing preferences and creating a CloudWatch billing alarm set at ₹100 ($1.20 USD) threshold to receive email notifications before costs escalate. I also enabled Free Tier usage alerts to track consumption of free resources and prevent unexpected charges. The billing alarm uses CloudWatch metrics (available only in us-east-1 region) with an SNS topic configured to send email notifications when estimated charges exceed the threshold. Additionally, I enabled automatic Free Tier alerts that notify at 85% usage of limits, helping prevent accidental charges while maximizing free learning resources. This proactive monitoring approach is essential for beginners to avoid bill shock from forgotten running resources like EC2 instances, NAT Gateways, or Load Balancers.

