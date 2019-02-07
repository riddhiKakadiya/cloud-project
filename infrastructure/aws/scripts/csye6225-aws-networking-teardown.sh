echo "Part 1.2 - Deleting Infrastructure Using AWS Command Line Interface"

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
    VpcId=$1
    res=$(aws ec2 describe-vpcs | jq -r '.Vpcs[].VpcId')
    getAllVPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[].VpcId')

    echo "Checking for VPC"
    for vpc in $getAllVPC; do
        if [ $vpc = "$VpcId" ]
        then
            echo "VPC found"

            echo "Getting InternetGatewayId"

            #-----------------------------
            # Deleting Internet Gateways
            #-----------------------------

            InternetGatewayId=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VpcId" | jq -r '.InternetGateways[0].InternetGatewayId')
            echo "InternetGatewayId : $InternetGatewayId"

            echo "Deteching Internet Gateway"
            aws ec2 detach-internet-gateway --internet-gateway-id "$InternetGatewayId" --vpc-id "$VpcId"

            echo "Deleting Internet Gaeway"
            aws ec2 delete-internet-gateway --internet-gateway-id "$InternetGatewayId"

            #-----------------------------
            # Deleting Route Tables
            #-----------------------------
            echo "Geting RouteTableId"

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

            #-----------------------------
            # Deleting SUBNETS
            #-----------------------------

            echo "Getting Subnet ID"

            SubnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId" | jq -r '.Subnets[].SubnetId')
            echo "SubnetId : $SubnetId"

            echo "Deleting Subnet"
            for subnet in $SubnetId; do
                echo "Deleting subnet : $subnet"
                aws ec2 delete-subnet --subnet-id "$subnet"
            done
            #-----------------------------
            # Deleting VPC
            #-----------------------------
            echo "Deleting VPC Start"
            aws ec2 delete-vpc --vpc-id "$VpcId"
            echo "Process completed successfully"            
        else
            echo "VPC not found"
        fi
    done
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