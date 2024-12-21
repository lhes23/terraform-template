#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
sudo systemctl start nginx
IP=$(curl -s https://icanhazip.com)
echo "<h1>This webserver Public IP: $IP</h1><h2>Hello World!</h2>" | sudo tee /var/www/html/index.nginx-debian.html > /dev/null
