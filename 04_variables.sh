#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ] 
then
    echo "you are not a root user"
    exit 1
    else
    echo "you are a root user"  
fi

sudo yum install mysql -y
 
if [ $? -ne 0 ]
then 
    echo "mysql is not installed"
else
    echo "my sql is installed"
fi
 


