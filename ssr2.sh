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
read -p "Please input your domain(like:https://ss.feiyang.li or http://114.114.114.114): " Userdomain
read -p "Please input your mukey(like:mupass): " Usermukey
read -p "Please input your Node_ID(like:1): " UserNODE_ID
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
	fi
}	