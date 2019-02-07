#import logging, boto3, time

#boto3.set_stream_logger('boto3', level=boto3.logging.DEBUG)
#boto3.set_stream_logger('botocore', level=boto3.logging.DEBUG)
#boto3.set_stream_logger('boto3.resources', level=boto3.logging.DEBUG)

#cf = boto3.client('cloudformation')

#create vpc
#!/bin/bash



#create stack (dynamically)

STACK_NAME=$1
#Check if stack name isnt passed empty
if [ $# -lt 1 ]; then
  echo "please provide a stack name!"
  exit 1
fi

stack_id=$(aws cloudformation create-stack --stack-name "$1" --template-body file://csye6225-cf-networking1.json)  
echo "creating stack $1"
echo "$stack_id"

aws cloudformation wait stack-create-complete --stack-name $1 
#cf.get_waiter('stack_create_complete').wait(StackName=$1)
echo "created stack $1"





