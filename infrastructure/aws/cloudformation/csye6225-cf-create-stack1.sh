#create vpc
#!/bin/bash
STACK_NAME=$1
#Check if stack name isnt passed empty
if [ $# -lt 1 ]; then
  echo "please provide a stack name!"
  exit 1
fi

#create stack (dynamically)
stack_id=$(aws cloudformation create-stack --stack-name "$1" --template-body file://csye6225-cf-networking.json --parameters ParameterKey=Name,ParameterValue=$1)  
echo "creating stack $1"
echo "$stack_id"
aws cloudformation wait stack-create-complete --stack-name $1 

echo "created stack $1"


