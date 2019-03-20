#!/bin/bash
sudo systemctl stop gunicorn
sudo systemctl stop nginx
sudo chown centos:centos /home/centos/webapp/*
sudo rm -rf /home/centos/webapp
sudo rm -rf /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml