#!/bin/bash
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
python3 /home/centos/webapp/WebProject/manage.py collectstatic
cd /home/centos/webapp/WebProject
deactivate
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

# sudo rm /etc/systemd/system/gunicorn.service
# sudo nano /etc/systemd/system/gunicorn.service

# sudo rm /etc/nginx/nginx.conf
# sudo nano /etc/nginx/nginx.conf



# sudo systemctl daemon-reload
# sudo systemctl restart nginx
# sudo systemctl enable nginx
# sudo systemctl daemon-reload
# sudo systemctl restart gunicorn
# sudo systemctl enable gunicorn
# python3 /home/centos/webapp/WebProject/manage.py runserver 0.0.0.0:8000 --settings=WebProject.settings_test