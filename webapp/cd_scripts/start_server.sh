#!/bin/bash
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
python /home/centos/webapp/WebProject/manage.py runserver 0.0.0.0:8000 --settings=WebProject.settings_test