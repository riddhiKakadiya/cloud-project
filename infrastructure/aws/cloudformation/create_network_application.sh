#!/bin/bash

#Exit immediately if a command exits with a non-zero exit status.
set -e


##Check if enough arguements are passed
if [ $# -lt 1 ]; then
  echo "Please provide network stack name ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <AMI_ID> <KEY_PAIR>"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "Please provide application stack name ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <AMI_ID> <KEY_PAIR>"
  exit 1
fi

if [ $# -lt 3 ]; then
  echo "Please provide ami id ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <AMI_ID> <KEY_PAIR>"
  exit 1
fi

if [ $# -lt 4 ]; then
  echo "Please provide ami id ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <AMI_ID> <KEY_PAIR>"
  exit 1
fi

./csye6225-aws-cf-create-stack.sh $1

./csye6225-aws-cf-create-application-stack.sh $2 $1 $3 $4