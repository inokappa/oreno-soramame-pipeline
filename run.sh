#!/bin/sh

TABLE_NAME="soramame_`date --date '1 day ago' +%Y-%m-%d`"
#
cd /app/
./create-table.rb ${TABLE_NAME}
if [ $? = "0" ];then
  sleep 3
  cd /app/
  ./put-record.rb ${TABLE_NAME}
fi
#
if [ $? = "0" ];then
  sleep 3
  cd /app/
  ./query-item.rb ${TABLE_NAME}
  if [ ! $? = "0" ];then
    echo "query-item.rb fail."
    exit 1
fi
else
  echo "put-record.rb fail."
  exit 1
fi
#
#cd /app
#./delete-table.rb ${TABLE_NAME}
#if [ ! $? = "0" ];then
#  echo "put-record.rb fail."
#  exit 1
#fi
