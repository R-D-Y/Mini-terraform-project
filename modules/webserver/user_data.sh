#!/bin/bash

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
sudo touch /var/www/html/index.html
sudo chmod o+w /var/www/html/index.html
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
