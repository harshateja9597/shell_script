#!/bin/bash

USER=$(id -u)

if [ $USER !e 0 ] {
    echo "you are not a root user"
    exit 1
    else
    echo "you are a root user"  
}
fi
 


