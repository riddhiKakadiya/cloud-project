VPCS=$(aws ec2 describe-vpcs | jq -r '.Vpcs')
echo $VPCS | jq -c '.[]'  | while read i; do
    VPC_ID=$(echo $i | jq -r '.VpcId')
    SECURITY_GRP_ID=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$VPC_ID" | jq -r '.SecurityGroups[0].GroupId')
	echo $SECURITY_GRP_ID

	# aws ec2 delete-security-group --group-id $SECURITY_GRP_ID

	SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" | jq -r '.Subnets')
	echo $SUBNETS | jq -c '.[]'  | while read i; do
	    SUBNET=$(echo $i | jq -r '.SubnetId')
	    aws ec2 delete-subnet --subnet-id $SUBNET
	done
	ROUTE_TABLES=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID"| jq -r '.RouteTables')
	echo $ROUTE_TABLES | jq -c '.[]'  | while read i; do
	    RT=$(echo $i | jq -r '.RouteTableId')
	    aws ec2 delete-route-table --route-table-id $RT
	done

	INTERNET_GATEWAYS=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID"| jq -r '.InternetGateways')
	echo $INTERNET_GATEWAYS | jq -c '.[]'  | while read i; do
	    IG=$(echo $i | jq -r '.InternetGatewayId"')
	    aws ec2 delete-internet-gateway --internet-gateway-id $IG
	done

	aws ec2 delete-vpc --vpc-id $VPC_ID
done

