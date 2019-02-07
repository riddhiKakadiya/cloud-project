#!/bin/sh

echo "Starting Script to Delete VPC"
echo "Input one of the VPC to delete :"
VPCS=$(aws ec2 describe-vpcs | jq -r '.Vpcs')

VPC_ARRAY=(all)

for row in $(echo $VPCS | jq -c '.[]'); do
   	VPC=$(echo $row | jq -r '.VpcId')
	echo "$VPC"
	VPC_ARRAY+=($VPC)
done

function deleteVPC()
{
#-----------------------------
# Deleting SUBNETS
#-----------------------------
	VPC_ID=$1
	echo "Deleting VPC : $VPC_ID"

    SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" | jq -r '.Subnets')
	echo $SUBNETS | jq -c '.[]'  | while read i; do
	    SUBNET=$(echo $i | jq -r '.SubnetId')
	    echo "Deleting Subnet : $SUBNET"
	    aws ec2 delete-subnet --subnet-id $SUBNET
	    if [ $? = "0" ]
			then
				echo "Deleted Subnet successfully : $SUBNET"
			else
				echo "Error : $SUBNET Not Deleted"
				exit
		fi
	done

#-----------------------------
# Deleting Internet Gateways
#-----------------------------

	INTERNET_GATEWAYS=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID"| jq -r '.InternetGateways')
	echo $INTERNET_GATEWAYS | jq -c '.[]'  | while read i; do
	    IG=$(echo $i | jq -r '.InternetGatewayId')
	    echo "Deleting Internet Gateway : $IG"
	    aws ec2 detach-internet-gateway --internet-gateway-id $IG --vpc-id $VPC_ID
	    aws ec2 delete-internet-gateway --internet-gateway-id $IG
	    if [ $? = "0" ]
			then
				echo "Deleted Internet Gateway  successfully : $IG"
			else
				echo "Error : $IG Not Deleted"
				exit
		fi
	done

#-----------------------------
# Deleting Route Tables
#-----------------------------

	# Error mentioned in https://github.com/aws/aws-cli/issues/1549
	ROUTE_TABLES=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID"| jq -r '.RouteTables')
	echo $ROUTE_TABLES | jq -c '.[]'  | while read i; do
	    RT=$(echo $i | jq -r '.RouteTableId')
	    echo "Deleting Route Table : $RT"
	    aws ec2 delete-route-table --route-table-id $RT
	    if [ $? = "0" ]
			then
				echo "Deleted Route Table  successfully : $RT"
			else
				echo "Error : $RT Not Deleted"
		fi
	done

#-----------------------------
# Deleting VPC
#-----------------------------

	echo "Deleting VPC : $VPC_ID"
	aws ec2 delete-vpc --vpc-id $VPC_ID
	if [ $? = "0" ]
		then
			echo "Deleted VPC  successfully : $VPC_ID"
		else
			echo "Error : $VPC_ID Not Deleted"
	fi
}

VPC_FLAG=true

while $VPC_FLAG; do
	echo "Enter the VPC ID to delete VPC group (default : all), followed by [ENTER]:"
	read VPC_ID
	VPC_ID=${VPC_ID:-all}
	if [[ " ${VPC_ARRAY[*]} " == *$VPC_ID* ]]; then
	    VPC_FLAG=false
	else
		echo "Invalid parameter provided, please input again"
	fi
done 

if [[ $VPC_ID == "all" ]]; then
	    VPCS_ALL=$(aws ec2 describe-vpcs | jq -r '.Vpcs')
		echo $VPCS_ALL | jq -c '.[]'  | while read k; do
		    VPC_ONE=$(echo $k | jq -r '.VpcId')
		    deleteVPC $VPC_ONE
		done
	else
		deleteVPC $VPC_ID
fi

echo "End of Script"
exit
