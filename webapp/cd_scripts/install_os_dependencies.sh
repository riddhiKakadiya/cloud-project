#!/bin/bash
sudo cp /home/centos/webapp/cd_scripts/gunicorn.service /etc/systemd/system/gunicorn.service
sudo cp /home/centos/webapp/cd_scripts/nginx.conf /etc/nginx/nginx.conf
sudo cp -rf /home/centos/webapp/cd_scripts/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo cp -rf /home/centos/my.cnf /home/centos/webapp/WebProject/WebProject/config/my.cnf
sudo mkdir --parents /etc/systemd/system/nginx.service.d/; sudo mv /home/centos/webapp/cd_scripts/override.conf $_
sudo yum install jq -y

