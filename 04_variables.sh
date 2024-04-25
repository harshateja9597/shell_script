#!/bin/bash

USER=$(id -u)

if [ $USER -ne 0 ] 
then
    echo "you are not a root user"
    exit 1
    else
    echo "you are a root user"  
fi
 


