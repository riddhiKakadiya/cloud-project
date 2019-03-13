#!/bin/bash

source /home/centos/webapp/WebProject/djangoEnv/bin/activate
# python3 /home/centos/webapp/WebProject/manage.py collectstatic
sudo scl enable rh-python36 "source /home/centos/webapp/WebProject/djangoEnv/bin/activate && python3 /home/centos/webapp/WebProject/manage.py makemigrations"
sudo scl enable rh-python36 "source /home/centos/webapp/WebProject/djangoEnv/bin/activate && python3 /home/centos/webapp/WebProject/manage.py migrate"
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