#!/bin/bash
# sudo scl enable rh-python36 bash
# sudo yum install python36-dev
# sudo yum install epel-release -y
# sudo yum makecache
# sudo yum search pip | grep python3
# sudo yum install python36-setuptools -y
# sudo yum install python36-pip -y
# sudo easy_install-3.6 pip
# sudo scl enable rh-python36 bash
# pip3 install virtualenv
sudo mv /home/centos/webapp/cd_scripts/gunicorn.service /etc/systemd/system/gunicorn.service
sudo mv /home/centos/webapp/cd_scripts/nginx.conf /etc/nginx/nginx.conf
sudo mkdir --parents /etc/systemd/system/nginx.service.d/; sudo mv /home/centos/webapp/cd_scripts/override.conf $_
sudo scl enable rh-python36 bash
sudo chown centos:centos /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*
sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*
virtualenv -p python3.6 /home/centos/webapp/WebProject/djangoEnv

