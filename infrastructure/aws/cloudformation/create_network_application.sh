#!/bin/bash

#Exit immediately if a command exits with a non-zero exit status.
set -e
##Check if enough arguements are passed
if [ $# -lt 1 ]; then
  echo "Please provide network stack name ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <KEY_PAIR>"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "Please provide application stack name ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <KEY_PAIR>"
  exit 1
fi

if [ $# -lt 3 ]; then
  echo "Please provide Key Pair ! Try Again."
  echo "e.g. ./csye6225-aws-cf-create-stack.sh <STACK_NAME> <NETWORK_STACK> <KEY_PAIR>"
  exit 1
fi

IMAGE_ID=$(aws ec2 describe-images --owners self --query 'sort_by(Images, &CreationDate)[].ImageId' | jq -r '.[0]')

S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("csye6225")).Name')

S3_BUCKET_CD=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')

./csye6225-aws-cf-create-stack.sh $1

./csye6225-aws-cf-create-application-stack.sh $2 $1 $IMAGE_ID $3 $S3_BUCKET

echo "Enter Token for Circle CI, followed by [ENTER]:"
read CI_Token

echo "Enter Username for Github, followed by [ENTER]:"
read USERNAME

echo "Enter Branch for Github, followed by [ENTER]:"
read Branch

curl -u $CI_Token -d build_parameters[CIRCLE_JOB]=build https://circleci.com/api/v1.1/project/github/$USERNAME/csye6225-spring2019/tree/$Branch