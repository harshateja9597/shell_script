#!/bin/bash

id=$(id -u)
r="\e[31m"
g="\e[32m"
b="\e[33m"
n="\e[0m"

timestamp=$(date)
logfile="/tmp/$0-$timestamp.log"
mongodb_host=mongodb.jigel.online

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

dnf module disable nodejs -y

validate $? "disabling current nodejs" &>> $logfile

dnf module enable nodejs:18 -y

validate $? "enabling nodejs:18" &>> $logfile

dnf inatall  nodejs -y

validate $? "installing nodejs:18" &>> $logfile

useradd roboshop

validate $? "addng roboshop user" &>> $logfile

mkdir /app

validate $? "creating app directory" &>> $logfile

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

validate $? "downloading ccatalogue application" &>> $logfile

cd /app

unzip /tmp/catalogue.zip

validate $? "unzipping catalogue" &>> $logfile

npm install 

validate $? "installing dependencies" &>> $logfile

#use absolute path because you are in another directory 
cp /home/centos/shell_script/catalogue.service /etc/systemd/system/catalogue.service

validate $? "copying catalogue.service file" &>> $logfile

systemctl daemon-reload

validate $? "catalogue daemon reload" &>> $logfile

systemctl enable catalogue

validate $? "enabling catalogue" &>> $logfile

systemctl start catalogue

validate $? "starting catalogue" &>> $logfile

cp /home/centos/shell_script/mongo.repo /etc/yum.repos.d/mongo.repo

validate $? "copying mongo.repo" &>> $logfile

dnf install mongodg-org-shell -y

validate $? "installing mongodb client"

mongodb --host $mongodb_host </app/schema/catalogue.js

validate $? "loading catalogue data into mongodb"