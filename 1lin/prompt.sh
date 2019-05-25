#!/bin/bash
#Usage:
# prompt when user login
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:.
export PATH
used=`/usr/sbin/repquota -u /storage/user/ | grep $USER | awk -F " " '{print $3}'`
limit=`/usr/sbin/repquota -u /storage/user/ | grep $USER | awk -F " " '{print $5}'
if [ $used -ge $limit ];then  #  这里是 是否大于指定大小
    echo "$USER had overflow, you can't add any files. please email contace administrator"
  fi
