#!/bin/bash
ls
sudo scl enable rh-python36 bash
source WebProject/djangoEnv/bin/activate
python WebProject/WebProject/manage.py runserver 0.0.0.0:80 --settings=WebProject.settings_test