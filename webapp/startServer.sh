#!/bin/bash
cd WebProject
sudo rm -rf djangoEnv
virtualenv -p python3 djangoEnv
source djangoEnv/bin/activate
pip install -r requirements.txt
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver