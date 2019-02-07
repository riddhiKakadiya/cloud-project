# CSYE 6225 - Spring 2019

## AWS CLI Scripts
This folder contains the shell scripts used to setup and teardown an AWS network.

### Architecture 
The architecture contains networking resources such as Virtual Private Cloud (VPC), Internet Gateway, Route Table and Routes.

#### Infrastructure setup:

1. Create a Virtual Private Cloud (VPC).
2. Create subnets in your VPC. You must create 3 subnets, each in different availability zone in the same region under same VPC.
3. Create Internet Gateway resource.
4. Attach the Internet Gateway to the created VPC.
5. Create a public Route Table. Attach all subnets created above to the route table.
6. Create a public route in the public route table created above with destination CIDR block 0.0.0.0/0 and internet gateway creted above as the target.
7. Modify the default security group for your VPC to remove existing rules and add new rules to only allow TCP traffic on port 22 and 80 from anywhere.

### Executing the scripts
To run the scripts please ensure that JQ is installed 
JQ can be installed via the following command:

```bash
sudo apt-get install jq
```

Make sure that the output of aws cli is in json format

```bash
AWS Access Key ID [****************57CQ]: 
AWS Secret Access Key [****************64aV]: 
Default region name [us-east-1]: 
Default output format [json]: json
```

To run the script for creating the network stack :

```bash
cd csye6225-spring2019/infrastructure/aws/scripts
bash csye6225-aws-networking-setup.sh
```

To run the script for deleting the network stack :

```bash
cd csye6225-spring2019/infrastructure/aws/scripts
bash csye6225-aws-networking-teardown.sh
```