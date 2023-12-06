#!/bin/bash
yum install httpd -y
echo "<h2> This demo for apache in terraform script </h2>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd
