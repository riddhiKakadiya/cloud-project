echo "Part 1.2 - Deleting Infrastructure Using AWS Command Line Interface"

echo enter vpc id
read VpcId

res=$(aws ec2 describe-vpcs | jq -r '.Vpcs[].VpcId')
getAllVPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[].VpcId')

echo "Checking for VPC"
for vpc in $getAllVPC; do
    if [ $vpc = "$VpcId" ]
    then
        echo "VPC found"

echo "Getting InternetGatewayId"

#gateway_response=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VpcId")
#echo $gateway_response
InternetGatewayId=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VpcId" | jq -r '.InternetGateways[0].InternetGatewayId')
echo "InternetGatewayId : $InternetGatewayId"

echo "Deteching Internet Gateway"
aws ec2 detach-internet-gateway --internet-gateway-id "$InternetGatewayId" --vpc-id "$VpcId"

echo "Deleting Internet Gaeway"
aws ec2 delete-internet-gateway --internet-gateway-id "$InternetGatewayId"

echo "Geting RouteTableId"
#route_table_response=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VpcId" "Name=association.main,Values=false")
#echo $route_table_response
RouteTableId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VpcId" "Name=association.main,Values=false" | jq -r '.RouteTables[].RouteTableId')
echo "RouteTableId : $RouteTableId"

echo "Geting RouteTableAssociation ID"
RouteTableAssociationId=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VpcId" "Name=association.main,Values=false" | jq -r '.RouteTables[0].Associations[].RouteTableAssociationId')
echo "RouteTableAssociationId : $RouteTableAssociationId"

echo "Disassociating a route table"
for routeAssID in $RouteTableAssociationId; do
    echo "Disassociating route table : $routeAssID"
    res=$(aws ec2 disassociate-route-table --association-id "$routeAssID")
done

echo "Deleting Route Table"
aws ec2 delete-route-table --route-table-id "$RouteTableId"

echo "Getting Subnet ID"
#subnet_response=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId")
SubnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId" | jq -r '.Subnets[].SubnetId')
echo "SubnetId : $SubnetId"

echo "Deleting Subnet"
for subnet in $SubnetId; do
    echo "Deleting subnet : $subnet"
    aws ec2 delete-subnet --subnet-id "$subnet"
done

echo "Deleting VPC Start"
aws ec2 delete-vpc --vpc-id "$VpcId"
echo "Process completed successfully"

        exit
    else
        echo "VPC not found"
    fi
   
done