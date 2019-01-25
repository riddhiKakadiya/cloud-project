#!/bin/bash
#Run with sudo permisions
echo Setingup Dev environment
sudo rm -rf djangoEnv
sudo apt-get update
sudo apt-get install virtualenv python3-pip mysql-server
virtualenv -p python3 djangoEnv
 
source djangoEnv/bin/activate
pip3 install -r requirements.txt

cd WebProject
python3 manage.py runserver
