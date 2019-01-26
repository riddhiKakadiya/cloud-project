# CSYE 6225 - Spring 2019

## Team Information

| Name | NEU ID | Email Address |
| --- | --- | --- |
| Jai Soni| | |
| Krapali Rai| | |
| Riddhi Kakadiya| | |
| Sreerag Mandakathil Sreenath| 001838559| mandakathil.s@husky.neu.edu|


## Technology Stack
The web application is build on Django-python based backend service and uses MySql for the relational Database

## System Setup
Install the following system requirements:
1. Python3
2. Python3 pip
3. MySQL Server

### First Time Dev Setup
1. Create a database in your MySql server
2. Duplicate my.cnf.sample and rename it to my.cnf
3. Edit the database connection details there

**Optional**
You may use the initSetup.sh to install all the required libraries and to start server

```bash
source /webapp/initSetup.sh -u YOURUSERNAME -p YOURPASSWORD -d YOURDBNAME
```

### Dev Setup
To run django server
1. Start the virtualenv
2. Execute run server command

```bash
cd /webapp
source djangoEnv/bin/activate
cd /WebProject
python3 manage.py runserver
```


## Build Instructions


## Deploy Instructions


## Running Tests


## CI/CD


