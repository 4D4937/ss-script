#!/usr/bin/env bash
#安装依赖
yum install openssl openssl-devel zlib-devel gcc -y
# apt-get install libssl-dev
# apt-get install openssl openssl-devel
# 下载源码
wget http://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
tar -zxvf Python-2.7.12.tgz
cd Python-2.7.12
mkdir /usr/local/python2.7.12
# 开启zlib编译选项
# sed -i '467c zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz' Module/Setup
sed '467s/^#//g' Module/Setup

./configure --prefix=/usr/local/python2.7.12 
make
make install
if [ $? -eq 0 ];then
     echo "Python2.7.12升级完成"
else
     echo "Python2.7.12升级失败，查看报错信息手动安装"
fi
cd
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/python2.7.12/bin/python2.7 /usr/bin/python

sed -i '1s/python/python2.6/g' /usr/bin/yum
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python get-pip.py
if [ $? -eq 0 ];then
     echo "pip升级完成"
else
     echo "pip安装失败，查看报错信息手动安装"
fi
rm -rf /usr/bin/pip
ln -s /usr/local/python2.7.12/bin/pip2.7 /usr/bin/pip

