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

dnf module disable nodejs -y &>> $logfile

validate $? "disabling current nodejs" 

 dnf module enable nodejs:18 -y &>> $logfile

validate $? "enabling nodejs:18" 

dnf inatall  nodejs -y &>> $logfile

validate $? "installing nodejs:18" 

useradd roboshop &>> $logfile

validate $? "addng roboshop user" 

mkdir /app &>> $logfile

validate $? "creating app directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $logfile

validate $? "downloading ccatalogue application" 

cd /app &>> $logfile

unzip /tmp/catalogue.zip &>> $logfile

validate $? "unzipping catalogue" 

npm install &>> $logfile

validate $? "installing dependencies" 

#use absolute path because you are in another directory 
cp /home/centos/shell_script/catalogue.service /etc/systemd/system/catalogue.service &>> $logfile

validate $? "copying catalogue.service file" 

systemctl daemon-reload &>> $logfile

validate $? "catalogue daemon reload" 

systemctl enable catalogue &>> $logfile

validate $? "enabling catalogue" 

systemctl start catalogue &>> $logfile

validate $? "starting catalogue" 

cp /home/centos/shell_script/mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile

validate $? "copying mongo.repo" 

dnf install mongodg-org-shell -y &>> $logfile

validate $? "installing mongodb client"

mongodb --host $mongodb_host </app/schema/catalogue.js &>> $logfile

validate $? "loading catalogue data into mongodb"