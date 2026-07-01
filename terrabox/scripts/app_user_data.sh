#!/bin/bash
# Bootstrap script for application-tier instances (Amazon Linux 2023)
set -euxo pipefail

dnf update -y
dnf install -y nginx

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $(curl -s -X PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<HTML > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
  <head><title>Terrabox 3-Tier Demo</title></head>
  <body style="font-family: sans-serif; text-align: center; margin-top: 10%;">
    <h1>Terrabox App Tier</h1>
    <p>Served by instance <strong>${INSTANCE_ID}</strong> in <strong>${AZ}</strong></p>
  </body>
</html>
HTML

systemctl enable nginx
systemctl start nginx
