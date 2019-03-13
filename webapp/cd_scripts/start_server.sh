#!/bin/bash


# python3 /home/centos/webapp/WebProject/manage.py collectstatic
python3 /home/centos/webapp/WebProject/manage.py makemigrations
python3 /home/centos/webapp/WebProject/manage.py migrate
cd /home/centos/webapp/WebProject
#Import must read !!
sudo systemctl daemon-reload
PROFILE=dev && sudo systemctl start gunicorn
PROFILE=dev && sudo systemctl restart gunicorn
PROFILE=dev && sudo systemctl enable gunicorn
sudo usermod -a -G centos nginx
chmod 710 /home/centos
sudo nginx -t
sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl enable nginx