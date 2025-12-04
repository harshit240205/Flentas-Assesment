#!/bin/bash
# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create HTML page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HA Auto Scaling Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
        }
        .info-box {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
        }
        .label {
            font-weight: bold;
            color: #ffd700;
        }
        .value {
            font-size: 1.2em;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 High Availability Demo</h1>
        <div class="info-box">
            <div class="label">Instance ID:</div>
            <div class="value">$INSTANCE_ID</div>
        </div>
        <div class="info-box">
            <div class="label">Availability Zone:</div>
            <div class="value">$AVAILABILITY_ZONE</div>
        </div>
        <div class="info-box">
            <div class="label">Private IP:</div>
            <div class="value">$PRIVATE_IP</div>
        </div>
        <div class="info-box">
            <div class="label">Status:</div>
            <div class="value">✅ Running & Healthy</div>
        </div>
        <p style="text-align: center; margin-top: 30px; font-size: 0.9em;">
            Refresh this page to see different instances (load balancing in action!)
        </p>
    </div>
</body>
</html>
EOF

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Configure firewall (if needed)
systemctl stop firewalld
systemctl disable firewalld