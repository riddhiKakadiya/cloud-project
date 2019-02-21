#!/bin/bash
sudo scl enable rh-python36 bash
sudo rm -rf djangoEnv
virtualenv -p python djangoEnv
source djangoEnv/bin/activate
cat requirements.txt | xargs -n 1 pip install
cd WebProject
python manage.py runserver 0.0.0.0:80