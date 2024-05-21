#!/bin/bash

id=$(id -u)
r="\e[31m"
g="\e[32m"
b="\e[33m"
n="\e[0m"

timestamp=$(date)
logfile="/tmp/$0-$timestamp.log"

echo "script started executing at $timestamp" &>> $logfile 

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 $r failed $n"
    else
        echo -e "$2 $g success $n"
    fi
}

if [ $id -ne 0 ]
then
    echo -e "$r you are not a root user $n"
else
    echo -e "$g you are root user $n"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile

validate $? "copied mongodb repo"

dnf install mongodb-org -y &>> $logfile

validate $? "installing mongodb"

systemctl enable mongod &>> $logfile

validate $? "enabling mongod"

systemctl start mongod &>> $logfile

validate $? "starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $logfile

validate $? "adding remote access to mongodb"

systemctl restart mongod &>> $logfile

validate $? "restarted mongod"





