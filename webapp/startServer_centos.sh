#!/bin/bash
ls
sudo scl enable rh-python36 bash
source /home/centos/webapp/WebProject/djangoEnv/bin/activate
pip install -r /home/centos/webapp/WebProject/requirements.txt
python /home/centos/webapp/WebProject/manage.py runserver 0.0.0.0:8000 --settings=WebProject.settings_test