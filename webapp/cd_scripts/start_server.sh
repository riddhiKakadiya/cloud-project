#!/bin/bash
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
python3 /home/centos/webapp/WebProject/manage.py collectstatic
cd /home/centos/webapp/WebProject
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