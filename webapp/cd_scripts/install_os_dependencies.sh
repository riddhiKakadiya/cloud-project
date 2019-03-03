#!/bin/bash
sudo yum install epel-release -y
sudo yum makecache
sudo yum search pip | grep python3
sudo yum install python36-pip -y
sudo pip3 install virtualenv