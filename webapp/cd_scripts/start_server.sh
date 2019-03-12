#!/bin/bash
sudo semanage permissive -a httpd_t 
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
export S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')
export PROFILE=dev

# python3 /home/centos/webapp/WebProject/manage.py collectstatic
python3 /home/centos/webapp/WebProject/manage.py makemigrations
python3 /home/centos/webapp/WebProject/manage.py migrate
cd /home/centos/webapp/WebProject
#Import must read !!
sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl restart gunicorn
sudo systemctl enable gunicorn
sudo usermod -a -G centos nginx
chmod 710 /home/centos
sudo nginx -t
sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl enable nginx
