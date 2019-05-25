#!/bin/bash
#Program: moniter user of quota.
#History: 19/5/1 gorkr
#Usage:
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:.
export PATH


user=`/usr/sbin/repquota -u /storage/user/ | tail -n +7 | awk -F ' ' '{print $1}'`  # all of users wrote in quota, excipt root

for i in ${user}  # $user和${user}一样吗
    do
        used=`/usr/sbin/repquota -u /storage/user/ | grep $i | awk -F " " '{print $3}'`
        limit=`/usr/sbin/repquota -u /storage/user/ | grep $i | awk -F " " '{print $5}'`
        if [ $used -ge $limit ];then  #  这里是 是否大于指定大小
	        date=`date +%Y%m%d`
            tar -czvf /storage/safeplace/${i}-${date}.tar.gz /storage/user/home/${i}/  # 将制定路径打包， 将其存放在指定目录
            rm -rf /storage/user/home/${i}/*  # 将文件删除
        fi
    done


function login {
    #记录登录到本机的用户名，登录时间和登陆地点
    usrname=$USER 
    time=`date +%y-%m-%d\ %H:%M:%S`
    termenal=`ps | grep bash | grep -v grep | awk '{print $2}'`
    location=`w | grep "$termenal" | awk '{print $3}'`
    if [[ "$location"=~'-' ]] || [[ "$location"=~^':' ]]; then
    location="localhost"
    fi
    echo -e "$username\t$time\t$location" >> /var/log/login
}

function prompt {
    username=$USER
    if [ $username == "root" ] || [ $username == "rugbadmin" ] || [ $username == "supinfo" ]
    then
	    exit 1
	    fi
    used=`/usr/sbin/repquota -u /storage/user/ | grep $username | awk -F " " '{print $3}'`
    limit=`/usr/sbin/repquota -u /storage/user/ | grep $username | awk -F " " '{print $5}'`
     if [ $used -ge $limit ]
     then 
         echo "$username, you are locked, please contact administraor to get you files."
     else
         echo "$username, you have used $used, please not over $limit, be careful."
     fi  
}

prompt
