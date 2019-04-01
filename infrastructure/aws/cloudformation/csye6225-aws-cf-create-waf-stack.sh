#!/bin/bash

#Exit immediately if a command exits with a non-zero exit status.
set -e

##Creating Stack
echo "Creating Stack waf"
response=$(aws cloudformation create-stack --stack-name "waf" --template-body file://owasp_10_base.yml) 
#response=$(aws cloudformation create-stack --stack-name "$1" --template-body file://csye6225-cf-networking.yaml)
echo "Waiting for Stack waf to be created"
echo "$response"
aws cloudformation wait stack-create-complete --stack-name "waf"
echo "Stack waf created successfully"

aws cloudformation describe-stack-resources --stack-name "waf"| jq '.StackResources' | jq -c '.[]' | jq '.PhysicalResourceId'