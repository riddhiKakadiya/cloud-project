# CSYE 6225 - Spring 2019

## AWS CLI Scripts
This folder contains the shell scripts used to setup and teardown an AWS network.

### Architecture 
The architecture contains networking resources such as Virtual Private Cloud (VPC), Internet Gateway, Route Table and Routes.

####  infrastructure setup:

1. Create a Virtual Private Cloud (VPC) resource called STACK_NAME-csye6225-vpc.
2. Create subnets in your VPC. You must create 3 subnets, each in different availability zone in the same region under same VPC.
3. Create Internet Gateway resource called STACK_NAME-csye6225-ig.
4. Attach the Internet Gateway to STACK_NAME-csye6225-vpc VPC.
5. Create a public Route Table called STACK_NAME-csye6225-rt. Attach all subnets created above to the route table.
6. Create a public route in STACK_NAME-csye6225-rt route table with destination CIDR block 0.0.0.0/0 and STACK_NAME-csye6225-ig as the target.
7. Modify the default security group for your VPC to remove existing rules and add new rules to only allow TCP traffic on port 22 and 80 from anywhere.

### Executing the scripts
To run the script for creating the network stack :

```bash
cd csye6225-spring2019/infrastructure/scripts
sh csye6225-aws-networking-setup.sh
```

To run the script for deleting the network stack :

```bash
cd csye6225-spring2019/infrastructure/scripts
sh csye6225-aws-networking-teardown.sh
```