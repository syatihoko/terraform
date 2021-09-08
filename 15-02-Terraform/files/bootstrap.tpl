#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
cd /var/www/html
sudo touch /var/www/html/index.html
sudo chown ec2-user /var/www/html/index.html
sudo echo "<html><h2>This is host $(hostname)</h2><img src="${file}"></html>" >> /var/www/html/index.html
sudo echo "<html><h1> Netology </h1></html>" >> /var/www/html/index.html
sudo wget https://${url}/${file}