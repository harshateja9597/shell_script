#!/bin/bash
DATE=$(date)

LOGFILE="/tmp/$0-$DATE.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "script started executing $DATE &>> $LOGFILE"


validate(){
    if [ $1 -ne 0 ]
then 
    echo -e " $R $2 $N not installed"
    exit 1
else
    echo -e "$G $2 $N installed"
fi
}

USER=$(id -u)

if [ $USER -ne 0 ] 
then
    echo -e " $R you are not a root user $N"
    exit 1
    else
    echo -e " $G you are a root user $N"  
fi

yum install mysql -y &>> $LOGFILE
 
validate $? "installing myql"

yum install git -y &>> $LOGFILE

validate $? "installing git"


