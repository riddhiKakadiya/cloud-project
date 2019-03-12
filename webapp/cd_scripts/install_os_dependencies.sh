#!/bin/bash
sudo mv /home/centos/webapp/cd_scripts/gunicorn.service /etc/systemd/system/gunicorn.service
sudo mv /home/centos/webapp/cd_scripts/nginx.conf /etc/nginx/nginx.conf
sudo mkdir --parents /etc/systemd/system/nginx.service.d/; sudo mv /home/centos/webapp/cd_scripts/override.conf $_
sudo scl enable rh-python36 "virtualenv -p python3.6 /home/centos/webapp/WebProject/djangoEnv"
sudo chown centos:centos /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*
sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/
sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*
