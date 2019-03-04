#!/bin/bash
# sudo yum install rh-python36 -y
# sudo scl enable rh-python36 bash
# sudo yum groupinstall 'Development Tools' -y
# sudo pip3 install virtualenv
sudo chown centos:centos /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*
virtualenv -p python3.6 /home/centos/webapp/WebProject/djangoEnv

# sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*
# source /home/centos/webapp/WebProject/djangoEnv/bin/activate
# pip3 install -r /home/centos/webapp/WebProject/requirements.txt