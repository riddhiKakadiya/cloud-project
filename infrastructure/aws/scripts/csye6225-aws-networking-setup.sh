#!/bin/sh
echo "Welcome to VPC creation script"
echo "Ensuring that the jq is installed"

echo "" |jq '.'
if [ $? = "0" ]
then
	echo "JQ is installed continuing with script"
	echo $VPC_ID
else
	echo "Error : JQ is not installed"
	sudo apt-get install jq
fi

AllowedPattern='^((\d{1,3})\.){3}\d{1,3}/\d{1,2}$'


###### Validating CIDR #######
function validate_cidr()
{	
	
    #RGX='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
    if echo $1 | grep -qP $AllowedPattern 
    then
        echo "valid: "$1
    else
        echo "not valid: "$1
        echo "switching back to default value"
    fi
}

##############################



#-----------------------------
# Getting input form user for region, subnet and cidr configuration
#-----------------------------

echo "The following are the regions available for creating VPC : "

REGIONS=$(aws ec2 describe-regions | jq '.Regions')
echo $REGIONS | jq -c '.[]'  | while read i; do
	REGION=$(echo $i | jq -r '.RegionName')
	    echo "$REGION"
done

echo ""
echo "Lets first configure your AWS account"
aws configure

echo "The following are the zones available for creating subnets : "

ZONE_ARRAY=()

AVAILABILITY_ZONES=$(aws ec2 describe-availability-zones | jq '.AvailabilityZones')
for row in $(echo $AVAILABILITY_ZONES | jq -c '.[]'); do
   	ZONE=$(echo $row | jq -r '.ZoneId')
	echo "$ZONE"
	ZONE_ARRAY+=($ZONE)
done


ZONE_FLAG=true

while $ZONE_FLAG; do
	echo "Enter the 1st Zone (default : use1-az1), followed by [ENTER]:"
	read ZONE1
	ZONE1=${ZONE1:-use1-az1}
	if [[ " ${ZONE_ARRAY[*]} " == *$ZONE1* ]]; then
	    ZONE_FLAG=false
	else
		echo "Invalid parameter provided, please input again"
	fi
done 

ZONE_FLAG=true

while $ZONE_FLAG; do
	echo "Enter the 2nd Zone (default : use1-az2), followed by [ENTER]:"
	read ZONE2
	ZONE2=${ZONE2:-use1-az2}
	if [[ " ${ZONE_ARRAY[*]} " == *$ZONE2* ]]; then
	    ZONE_FLAG=false
	else
		echo "Invalid parameter provided, please input again"
	fi
done

ZONE_FLAG=true

while $ZONE_FLAG; do
	echo "Enter the 3rd Zone (default : use1-az3), followed by [ENTER]:"
	read ZONE3
	ZONE3=${ZONE3:-use1-az3}
	if [[ " ${ZONE_ARRAY[*]} " == *$ZONE3* ]]; then
	    ZONE_FLAG=false
	else
		echo "Invalid parameter provided, please input again"
	fi
done


echo "Enter cidr value for VPC (default : 10.0.0.0/16), followed by [ENTER]:"
read VPC_CIDR
validate_cidr $VPC_CIDR
VPC_CIDR=${VPC_CIDR:-10.0.0.0/16}


echo "Enter cidr value for Subnets 1 : $ZONE1 (default : 10.0.1.0/24), followed by [ENTER]:"
read SUBNET1_CIDR
validate_cidr $SUBNET1_CIDR
SUBNET1_CIDR=${SUBNET1_CIDR:-10.0.0.0/24}

echo "Enter cidr value for Subnets 2 : $ZONE2 (default : 10.0.2.0/24), followed by [ENTER]:"
read SUBNET2_CIDR
validate_cidr $SUBNET2_CIDR
SUBNET2_CIDR=${SUBNET2_CIDR:-10.0.2.0/24}

echo "Enter cidr value for Subnets 3 : $ZONE3 (default : 10.0.3.0/24), followed by [ENTER]:"
read SUBNET3_CIDR
validate_cidr $SUBNET3_CIDR
SUBNET3_CIDR=${SUBNET3_CIDR:-10.0.3.0/24}


echo "Starting Script to Create VPC"
echo "Executing creation command : VPC "
#-----------------------------
# Creating VPC
#-----------------------------

VPC=$(aws ec2 create-vpc --cidr-block $VPC_CIDR  | jq -r '.')
VPC_ID=$(echo $VPC | jq -r '.Vpc.VpcId')

if [ $? = "0" ]
then
	echo "Created VPC Successfully"
	echo $VPC_ID
else
	echo "Error : VPC Not created"
	exit
fi

#-----------------------------
# Creating Subnet
#-----------------------------

SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET1_CIDR --availability-zone-id $ZONE1| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-1 in use-az1 Successfully"
	echo $SUBNET_ID_1
else
	echo "Error : Subnet-1 Not created"
	exit
fi

SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET2_CIDR --availability-zone-id $ZONE2| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-2 in use-az2 Successfully"
	echo $SUBNET_ID_2
else
	echo "Error : Subnet-2 Not created"
	exit
fi

SUBNET_ID_3=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET3_CIDR --availability-zone-id $ZONE3| jq -r '.Subnet.SubnetId')
if [ $? = "0" ]
then
	echo "Created Subnet-3 in use-az3 Successfully"
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
# Attaching Subnets to Route Table
#-----------------------------
ROUTE_TABLE_SUBNET_ASSOCIATION_ID_1=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1 | jq -r '.AssociationId')
if [ $? = "0" ]
then
	echo "Associated subnet to route table Successfully"
	echo $ROUTE_TABLE_SUBNET_ASSOCIATION_ID_1
else
	echo "Error : association of subnet to route table failed"
	exit
fi

ROUTE_TABLE_SUBNET_ASSOCIATION_ID_2=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2 | jq -r '.AssociationId')
if [ $? = "0" ]
then
	echo "Associated subnet to route table Successfully"
	echo $ROUTE_TABLE_SUBNET_ASSOCIATION_ID_2
else
	echo "Error : association of subnet to route table failed"
	exit
fi

ROUTE_TABLE_SUBNET_ASSOCIATION_ID_3=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_3 | jq -r '.AssociationId')
if [ $? = "0" ]
then
	echo "Associated subnet to route table Successfully"
	echo $ROUTE_TABLE_SUBNET_ASSOCIATION_ID_3
else
	echo "Error : association of subnet to route table failed"
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

#-----------------------------
# Attaching ingress rules to security group
#-----------------------------

SECURITY_GRP_ID=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$VPC_ID" | jq -r '.SecurityGroups[0].GroupId')
echo $SECURITY_GRP_ID

aws ec2 revoke-security-group-ingress --group-id $SECURITY_GRP_ID --protocol all --source-group $SECURITY_GRP_ID
if [ $? = "0" ]
then
	echo "Revoke public access Successfully"
else
	echo "Error : Revoke public access failed"
	exit
fi

aws ec2 authorize-security-group-ingress --group-id $SECURITY_GRP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0

if [ $? = "0" ]
then
	echo "Attached port 80 to security group Successfully"
else
	echo "Error : port 80 to security group Not attached"
	exit
fi

aws ec2 authorize-security-group-ingress --group-id $SECURITY_GRP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

if [ $? = "0" ]
then
	echo "Attached port 22 to security group Successfully"
else
	echo "Error : port 22 to security group Not attached"
	exit
fi


echo "End of Script"
exit
