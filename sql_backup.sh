#!/bin/bash
#source /etc/profile
cd /home/backup

mkdir -m 777 -p /home/backup/backup$(date +"%Y%m%d")

cp -r /home/wwwroot/www.liberty-ss.top /home/backup/backup$(date +"%Y%m%d")/sspanel

mysqldump -usspanel -pQ36kgrsd1R0aI5te databasename > /home/backup/backup$(date +"%Y%m%d")/sspanel.sql

tar -zcvf ./backup$(date +"%Y%m%d").tar.gz ./backup$(date +"%Y%m%d")

# echo "LIBERTY"|mutt -s "Backup$(date +%Y-%m-%d)" -a ./backup$(date +"%Y%m%d").tar.gz ssliberty666@gmail.com

# rm -rf /home/backup/backup$(date +"%Y%m%d")
# rm /home/backup/backup$(date +"%Y%m%d").tar.gz

rm -rf /home/backup/backup$(date -d -7day +"%Y%m%d")
rm -rf /home/backup/backup$(date -d -7day +"%Y%m%d").tar.gz
