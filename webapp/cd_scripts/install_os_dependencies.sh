#!/bin/bash
sudo scl enable rh-python36 bash
sudo yum install python34-setuptools -y
sudo easy_install-3.4 pip -y
pip3 install virtualenv