#!/bin/bash
sudo scl enable rh-python36 bash
source WebProject/djangoEnv/bin/activate
python WebProject/manage.py runserver 0.0.0.0:80