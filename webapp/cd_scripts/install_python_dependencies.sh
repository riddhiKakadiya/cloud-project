#!/bin/bash
sudo scl enable rh-python36 "source /home/centos/webapp/WebProject/djangoEnv/bin/activate && pip3 install -r /home/centos/webapp/WebProject/requirements.txt"
export S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')