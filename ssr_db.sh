#!/usr/bin/env bash
clear
########################################################
# System Required: CentOS 6+                           #
# Description: One click Install ShadowsocksR-Python   #
# Version: 1.2                                         #
# Author: T3ns0r                                       #
########################################################

config_file="/root/shadowsocks/userapiconfig.py"

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

Add_iptables(){
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1:65535 -j ACCEPT
	iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1:65535 -j ACCEPT
}

Save_iptables(){
	if [[ ${release} == "centos" ]]; then
		service iptables save
	else
		iptables-save > /etc/iptables.up.rules
	fi
}

# serverspeeder
wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh

# config
read -p "节点ID:" id_name
read -p "数据库地址:" sql_host
read -p "数据库:" sql_db
read -p "用户名:" sql_user
read -p "数据库密码:" sql_pw

View_User(){
        if [[ ${release} = "centos" ]]; then
		        echo -e " 数据库 配置信息：" && echo
                echo -e " 地址\t    : ${Green_font_prefix}${sql_host}${Font_color_suffix}"
				echo -e " 用户\t    : ${Green_font_prefix}${sql_user}${Font_color_suffix}"
				echo -e " 密码\t    : ${Green_font_prefix}${sql_pw}${Font_color_suffix}"
				echo -e " 数据库\t    : ${Green_font_prefix}${sql_db}${Font_color_suffix}"
		fi
}		
				
install_soft_for_each(){
	    check_sys
	    if [[ ${release} = "centos" ]]; then
	                yum update
		        yum install git -y
		        yum install python-setuptools && easy_install pip
		        yum -y groupinstall "Development Tools" -y
		        wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
		        tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
		        ./configure && make -j2 && make install
		        echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
		        ldconfig
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

install_soft_for_each
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

sed -i "2s/1/${id_name}/g" ${config_file}
sed -i "24s/127.0.0.1/${sql_host}/g" ${config_file}
sed -i "26s/ss/${sql_user}/g" ${config_file}
sed -i "27s/ss/${sql_pw}/g" ${config_file}
sed -i "28s/shadowsocks/${sql_db}/g" ${config_file}



echo enjoy it!
