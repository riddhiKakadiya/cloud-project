#!/bin/bash
sudo mv /home/centos/webapp/cd_scripts/gunicorn.service /etc/systemd/system/gunicorn.service
sudo mv /home/centos/webapp/cd_scripts/nginx.conf /etc/nginx/nginx.conf
sudo mkdir --parents /etc/systemd/system/nginx.service.d/; sudo mv /home/centos/webapp/cd_scripts/override.conf $_
sudo yum install jq -y

