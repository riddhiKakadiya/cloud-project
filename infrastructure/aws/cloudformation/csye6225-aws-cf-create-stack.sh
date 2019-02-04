#!/bin/bash

#Exit immediately if a command exits with a non-zero exit status.
set -e

##Check if enough arguements are passed
if [ $# -lt 1 ]; then
  echo "Please provide stack name ! Try Again."
  echo "e.g. ./csye6225-pring2019-aws-cf-create-stack.sh <STACK_NAME>"
  exit 1
fi

##Creating Stack
echo "Creating Stack $1"
response=$(aws cloudformation create-stack --stack-name "$1" --template-body file://csye6225-cf-networking.yaml)
echo "Waiting for Stack $1 to be created"
echo "$response"
aws cloudformation wait stack-create-complete --stack-name $1
echo "Stack $1 created successfully"
