#!/bin/bash
ls
sudo scl enable rh-python36 bash
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
python /home/centos/webapp/WebProject/WebProject/manage.py runserver 0.0.0.0:80 --settings=WebProject.settings_test