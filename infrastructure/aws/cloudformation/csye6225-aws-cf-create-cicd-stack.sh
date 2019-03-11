echo "Enter the stack name(cicd)"
read Stack_Name

echo -e "\n"
echo "Enter the Deployment group name, Code Deploy application name, S3 Bucket Name, Tag Key & Tag value of the ec2 instance you want to connect to deployment group."

aws cloudformation create-stack 
	--stack-name "$1" --template-body file://csye6225-cf-networking.yaml --capabilities CAPABILITY_NAMED_IAM --parameters  ParameterKey="$2",ParameterValue="$3" ParameterKey="$4",ParameterValue="$5" ParameterKey="S3bucketname",ParameterValue="$" ParameterKey="$",ParameterValue=$Tag_key ParameterKey="TagValue",ParameterValue=$Tag_value --disable-rollback