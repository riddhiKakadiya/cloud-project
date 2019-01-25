#!/bin/bash
#Run with sudo permisions
echo Setingup Dev environment

while getopts u:p:d: option
do
case "${option}"
in
u) USERNAME=${OPTARG};;
p) PASSWORD=${OPTARG};;
d) DATABASENAME=${OPTARG};;
esac
done

cat > WebProject/WebProject/config/my.cnf << EOF
# my.cnf
[client]
database = $DATABASENAME
user = $USERNAME
password = $PASSWORD
default-character-set = utf8
EOF

sudo rm -rf djangoEnv
sudo apt-get update
sudo apt-get install python3 virtualenv python3-pip mysql-server -y
virtualenv -p python3 djangoEnv

mysql --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASSWORD';" 
mysql --user="$USERNAME" --password="$PASSWORD" --execute="FLUSH PRIVILEGES;"

mysql --user="$USERNAME" --password="$PASSWORD" --execute="CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';"
mysql --user="$USERNAME" --password="$PASSWORD" --execute="GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'localhost' WITH GRANT OPTION;"
mysql --user="$USERNAME" --password="$PASSWORD" --execute="CREATE DATABASE $DATABASENAME;"

source djangoEnv/bin/activate
pip3 install -r requirements.txt
cd WebProject
python3 manage.py runserver
