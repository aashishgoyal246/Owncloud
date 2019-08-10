#!/bin/bash

# To install aws on machine

curl -O https://bootstrap.pypa.io/get-pip.py

yum install -y python36

python3 get-pip.py  

pip3 install awscli 

aws configure 
