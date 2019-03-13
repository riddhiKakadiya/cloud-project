echo "Enter the stack name(cicd),Deployment group name, Code Deploy application name, aws account id, Tag Key & Tag value of the ec2 instance you want to connect to deployment group."

aws cloudformation create-stack 
	--stack-name "$1" --template-body file://csye6225-cf-networking.yaml --capabilities CAPABILITY_NAMED_IAM --parameters  ParameterKey="Deploymentgroupname",ParameterValue="$2" ParameterKey="codedeployapplicationname",ParameterValue="$3" ParameterKey="aws_account_id",ParameterValue="$4" ParameterKey="TagKey",ParameterValue="$5" ParameterKey="TagValue",ParameterValue="$6" --disable-rollback

#create code deploy application and group
aws deploy create-application --application-name CodeDeployGitHubDemo-App

aws deploy create-deployment-group --application-name csye6225-webapp --ec2-tag-filters Key=ec2-tag-key,Type=KEY_AND_VALUE,Value=ec2-tag-value --on-premises-tag-filters Key=on-premises-tag-key,Type=KEY_AND_VALUE,Value=on-premises-tag-value --deployment-group-name csye6225-webapp-deployment --service-role-arn service-role-arn