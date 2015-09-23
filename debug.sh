#!/bin/sh

# TABLE_NAME="soramame_`date --date '1 day ago' +%Y-%m-%d`"
TABLE_NAME="soramame_`date -v-1d +"%Y-%m-%d"`"
#
./create-table.rb ${TABLE_NAME}
if [ $? = "0" ];then
  echo "create-table.rb ok."
  sleep 3
  ./put-record.rb ${TABLE_NAME}
fi
#
if [ $? = "0" ];then
  echo "put-record.rb ok."
  sleep 3
  ./query-item.rb ${TABLE_NAME}
  if [ ! $? = "0" ];then
    echo "query-item.rb fail."
    exit 1
  else
    echo "query-item.rb ok."
  fi
else
  echo "put-record.rb fail."
  exit 1
fi
#
#./delete-table.rb ${TABLE_NAME}
#if [ ! $? = "0" ];then
#  echo "put-record.rb fail."
#  exit 1
#fi

