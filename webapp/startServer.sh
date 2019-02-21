#!/bin/bash
sudo rm -rf djangoEnv
virtualenv -p python3 djangoEnv
source djangoEnv/bin/activate
pip install -r requirements.txt
cd WebProject
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver