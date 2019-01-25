#!/bin/bash
#Run with sudo permisions
echo Setingup Dev environment
sudo apt-get install virtualenv python3-pip
virtualenv -p python3 djangoEnv
source djangoEnv/bin/activate
pip3 install -r requirements.txt
