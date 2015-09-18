#!/bin/sh

cd /app/
./put-record.rb
if [ $? = "0" ];then
  sleep 
  cd /app/
  ./query-item.rb
  if [ ! $? = "0" ];then
    echo "query-item.rb fail."
    exit 1
fi
else
  echo "put-record.rb fail."
  exit 1
fi
