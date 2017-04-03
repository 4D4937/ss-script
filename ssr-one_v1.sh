#!/usr/bin/env bash

#git
yum install python-setuptools && easy_install pip
yum install git

#libsodium
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
#ssr
cd /root
git clone -b manyuser https://github.com/glzjin/shadowsocks.git
cd shadowsocks
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel
pip install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
