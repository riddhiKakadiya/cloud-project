#!/bin/bash
sudo chown centos:centos /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*
sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
pip3 install -r /home/centos/webapp/WebProject/requirements.txt
