#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Need the PID of the process to monitor"
    exit -1
fi

while true
do
   ps --no-headers -o rss -p $1
   sleep 1
done
