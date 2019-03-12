#!/bin/bash
export S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
python3 /home/centos/webapp/WebProject/manage.py collectstatic
cd /home/centos/webapp/WebProject
#Import must read !!
sudo semanage permissive -a httpd_t 
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
