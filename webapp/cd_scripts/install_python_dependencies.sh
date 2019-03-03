#!/bin/bash
chown centos:centos /home/centos/webapp
virtualenv /home/centos/webapp/WebProject/djangoEnv
chown centos:centos /home/centos/webapp/WebProject
chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
pip install -r /home/centos/webapp/WebProject/requirements.txt