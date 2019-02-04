#!/bin/sh

echo "Starting Script to Create VPC"
echo "Executing creation command : VPC "
#-----------------------------
# Creating VPC
#-----------------------------
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jq -r '.Vpc.VpcId')
if [ $? = "0" ]
then
	echo "Created VPC Successfully"
else
	echo "Error : VPC Not created"
	exit
fi

#-----------------------------
# Creating Subnet
#-----------------------------

SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone-id use1-az1| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-1 in use-az1 Successfully"
	echo $SUBNET_ID_1
else
	echo "Error : Subnet-1 Not created"
	exit
fi

SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone-id use1-az1| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-2 in use-az1 Successfully"
	echo $SUBNET_ID_2
else
	echo "Error : Subnet-2 Not created"
	exit
fi

SUBNET_ID_3=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.3.0/24 --availability-zone-id use1-az1| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-3 in use-az1 Successfully"
	echo $SUBNET_ID_3
else
	echo "Error : Subnet-3 Not created"
	exit
fi

#-----------------------------
# Creating Internet Gateway
#-----------------------------
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway | jq -r '.InternetGateway.InternetGatewayId')
if [ $? = "0" ]
then
	echo "Created Internet Gateway Successfully"
	echo $INTERNET_GATEWAY_ID
else
	echo "Error : Internet Gateway  Not created"
	exit
fi

#-----------------------------
# Attaching Internet Gateway to VPC
#-----------------------------

aws ec2 attach-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID --vpc-id $VPC_ID
if [ $? = "0" ]
then
	echo "Attached Intenet Gayway to VPC Successfully"
else
	echo "Error : Internet Gateway to VPC Not attached"
	exit
fi

#-----------------------------
# Creating Route Table
#-----------------------------
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID | jq -r '.RouteTable.RouteTableId')
if [ $? = "0" ]
then
	echo "Created Route Table Successfully"
	echo $ROUTE_TABLE_ID
else
	echo "Error : Route Table Not created"
	exit
fi

#-----------------------------
# Attaching Route table to Gateway
#-----------------------------
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $INTERNET_GATEWAY_ID
if [ $? = "0" ]
then
	echo "Attached Route Table to Intenet Gayway Successfully"
else
	echo "Error : Route Table to Intenet Gayway  Not attached"
	exit
fi
echo "End of Script"
exit

#-----------------------------
# Attaching Route table to Subnet
#-----------------------------
# aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1
# if [ $? = "0" ]
# then
# 	echo "Attached Intenet Gayway to VPC Successfully"
# 	echo $INTERNET_GATEWAY_ID
# else
# 	echo "Error : Internet Gateway to VPC Not attached"
# 	exit
# fi
