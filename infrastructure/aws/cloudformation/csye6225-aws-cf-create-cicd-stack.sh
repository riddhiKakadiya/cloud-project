echo "Enter the stack name(cicd),Deployment group name, Code Deploy application name, aws account id, Tag Key & Tag value of the ec2 instance you want to connect to deployment group."

AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
AWS_REGION="us-east-1"
CODE_DEPLOY_APPLICATION_NAME="csye6225-webapp"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
S3_BUCKET=$(aws s3api list-buckets | jq -r '.Buckets[] | select(.Name | startswith("code-deploy")).Name')

aws cloudformation create-stack --stack-name "$1" --template-body file://csye-cf-cicd.yaml --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=AWSAccountId,ParameterValue=$AWS_ACCOUNT_ID ParameterKey=CodeDeployApplicationName,ParameterValue=$CODE_DEPLOY_APPLICATION_NAME ParameterKey=AWSRegion,ParameterValue=$AWS_REGION ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET

echo "Waiting for Stack $1 to be created"
echo "$response"
aws cloudformation wait stack-create-complete --stack-name $1
echo "Stack $1 created successfully"

if [ $? = "0" ]
then
	aws iam create-access-key --user-name CircleCI1
else
	echo "Error : Creating user"
	exit
fi
echo "Bucket Name : "
echo $S3_BUCKET

echo "Input Circle CI Token: "
read TOKEN

echo "Input Circle CI URL: "
read URL

curl -u $TOKEN -d build_parameters[CIRCLE_JOB]=build $URL
