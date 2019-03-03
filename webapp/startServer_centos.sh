#!/bin/bash
cd WebProject
sudo scl enable rh-python36 bash
source WebProject/djangoEnv/bin/activate
cat WebProject/requirements.txt | xargs -n 1 pip install
python WebProject/manage.py runserver 0.0.0.0:80