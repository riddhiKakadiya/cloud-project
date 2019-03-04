#!/bin/bash
sudo yum install epel-release -y
sudo yum makecache
sudo yum search pip | grep python3
sudo yum install python36-setuptools -y
sudo yum install python36-pip -y
sudo easy_install-3.6 pip
sudo pip3 install virtualenv
sudo mv /home/centos/webapp/cd_scripts/gunicorn.service /etc/systemd/system/gunicorn.service
sudo mv /home/centos/webapp/cd_scripts/nginx.conf /etc/nginx/nginx.conf
sudo mv /home/centos/webapp/cd_scripts/override.conf /etc/systemd/system/nginx.service.d/override.conf
