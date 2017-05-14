#!/usr/bin/env bash
clear
echo
echo #=================================================
echo #	System Required: CentOS 6+
echo #	Description: One click Install ShadowsocksR-Python
echo #	Version: 1.1.0
echo #	Author: T3ns0r
echo #=================================================
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
install_soft_for_each(){check_sys
	    if [[ ${release} = "centos" ]]; then
		    yum install git -y
			git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git
			cd /root/shadowsocksr
			./setup_cymysql.sh
			./initcfg.sh
		fi
}

install_soft_for_each

