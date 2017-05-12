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
		yum install python-setuptools -y 
		yum -y groupinstall "Development Tools" -y
		wget https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
		tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
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
