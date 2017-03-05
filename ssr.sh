#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:  CentOS 6,7, Debian, Ubuntu                  #
#   Description: One click Install ShadowsocksR Server            #
#   Author: Sssssssssssao!!!                                      #
#   Thanks: @breakwa11 <https://twitter.com/breakwa11>            # 
#   Power for LIBERTY-SS                                          #
#=================================================================#



#Current folder
cur_dir=`pwd`
# Get public IP address
IP=$(ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1)
if [[ "$IP" = "" ]]; then
    IP=$(wget -qO- -t1 -T2 ipv4.icanhazip.com)
fi

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

# Check OS
function checkos(){
    if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='Ubuntu'
    else
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
    fi
}

# Get version
function getversion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else    
        grep -oE  "[0-9.]+" /etc/issue
    fi    
}

# CentOS version
function centosversion(){
    local code=$1
    local version="`getversion`"
    local main_ver=${version%%.*}
    if [ $main_ver == $code ];then
        return 0
    else
        return 1
    fi        
}

# Disable selinux
function disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
}

# Pre-installation settings
function pre_install(){
    # Not support CentOS 5
    if centosversion 5; then
        echo "Not support CentOS 5, please change OS to CentOS 6+/Debian 7+/Ubuntu 12+ and retry."
        exit 1
    fi
   
   
# Download files
function download_files(){
    # Download libsodium file
	if ! wget --no-check-certificate -O libsodium-1.0.10.tar.gz https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz; then
        echo "Failed to download libsodium file!"
        exit 1
	fi
    # Download ShadowsocksR file
	if [ "$OS" == 'CentOS' ]; then
        if ! wget --no-check-certificate -O shadowsocks git clone -b manyuser https://github.com/glzjin/shadowsocks.git; then
            echo "Failed to download Shadowsocks chkconfig file!"
            exit 1
		fi
	fi
}
		
    # Install necessary dependencies
    if [ "$OS" == 'CentOS' ]; then
	    apt-get -y update
	    yum install python-setuptools && easy_install pip
		yum install git
		yum -y groupinstall "Development Tools"
		tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
		./configure && make -j2 && make install
		echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
		ldconfig
	cd $cur_dir
}
# Installation dependent
     if [ "$OS" == 'CentOS' ]; then
		cd shadowsocks
		yum -y install python-devel
		yum -y install libffi-devel
		yum -y install openssl-devel
		pip install -r requirements.txt
		cp apiconfig.py userapiconfig.py
		cp config.json user-config.json
     fi
}

# optimization

