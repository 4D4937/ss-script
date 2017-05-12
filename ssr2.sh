#!/usr/bin/env bash
clear
echo
echo "#############################################################"
echo "# One click Install Shadowsocks-Python-Manyuser             #"
echo "# Github: https://github.com/mmmwhy/ss-panel-ss-py-mu       #"
echo "# Author: Feiyang.li                                        #"
echo "# Blog: https://feiyang.li/                                 #"
echo "#############################################################"
echo
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

#check OS version
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
install_soft_for_each(){
	check_sys
	if [[ ${release} = "centos" ]]; then
		echo "Will install below software on your centos system:"
		yum install git -y
		yum install python-setuptools && easy_install pip -y
		yum -y groupinstall "Development Tools" -y
		wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
		tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.10
		./configure && make -j2 && make install
		echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
		ldconfig
		yum install python-setuptools
		easy_install supervisor
	else
	apt-get update -y
	apt-get install supervisor -y
	apt-get install git -y
	apt-get install build-essential -y
	wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
	tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
	./configure && make -j2 && make install
	ldconfig
	fi
}

#clone shadowsocks
cd /root
git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
#install devel
cd /root/shadowsocks
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel
pip install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json

#iptables
iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
iptables-save

