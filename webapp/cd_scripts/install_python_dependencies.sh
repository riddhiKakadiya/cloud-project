#!/bin/bash
sudo scl enable rh-python36 "virtualenv -p python3.6 /home/centos/webapp/WebProject/djangoEnv"
sudo chown centos:centos /home/centos/webapp
sudo chown -R centos:centos /home/centos/webapp/*

sudo semanage permissive -a httpd_t 
sudo scl enable rh-python36 "source /home/centos/webapp/WebProject/djangoEnv/bin/activate && pip3 install -r /home/centos/webapp/WebProject/requirements.txt"

sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/
sudo chown centos:centos /home/centos/webapp/WebProject/djangoEnv/*

source /home/centos/webapp/WebProject/djangoEnv/bin/activate
export S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')
export PROFILE=dev