#!/bin/bash   

#定义有备份的数据库名 定义远程数据库
dbname="sspanel"  dbhost="localhost"

#定义远程数据库端口
dbport=3306

#定义备份数据库时使用的用户名和密码 
dbuser="sspanel" dbpasswd="pass"   
#数据库备份的路径 
backuppath=/home/backup
 
#数据库备份日志文件存储的路径 
logfile=/home/backup/logs/bak.log


#以当前的时间作为备份的数据库命名。 
dumpfile=${dbname}-$(date +%Y%m%d%H%M)   


#这个函数用来备份数据库 
back_db() {    
#将备份的时间、数据库名存入日志    
echo "------"$(date +%Y-%m-%d%t%A%t%T)" Beginning database "${dbname}" backup--------" >>${logfile}     


#备份数据库，如果有错误信息也记入日志。   默认utf8编码
/usr/bin/mysqldump -u${dbuser} -p${dbpasswd} -h ${dbhost} -P ${dbport} --default-character-set=utf8 --databases ${dbname} >${backuppath}${dumpfile}.sql 2>> ${logfile}     

#开始压缩数据文件   
echo $(date +%Y-%m-%d%t%A%t%T)" Beginning zip ${backuppath}${dumpfile}.sql" >>${logfile} 
    
#将备份数据库文件库压成ZIP文件，并删除先前的SQL文件。如果有错误信息也记入日志。   
tar zcvf ${dumpfile}.tar.gz ${dumpfile}.sql && rm ${dumpfile}.sql 2>> ${logfile}     

#将压缩后的文件名存入日志。   
echo "backup file name:"${dumpfile}".tar.gz" >>${logfile}   
echo -e "-------"$(date +%Y-%m-%d%t%A%t%T)" Ending database "${dbname}" backup-------\n" >>${logfile}  
}

#发送邮件  
#cat ${logfile} | mutt -s "sql_backup" -a ${dumpfile}.tar.gz zrhe2016@gmail.com }   

rm_oldfile() {   
#查找出当前目录下7天前生成的文件，并将之删除   
find ${backuppath} -type f -mtime +7 -exec rm {} \; 
}   

#切换到数据库备份的目录。如果不做这个操作，压缩文件时有可能会错误 
cd ${backuppath}   

#运行备份数据函数 
back_db   

#运行删除文件函数 
rm_oldfile
