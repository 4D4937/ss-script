#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# config
config_file="/root/shadowsocks/userapiconfig.py"
read -p "模式选择(1.glzjinmod, 2.modwebapi):" api_mode
read -p "节点ID:" id_name
read -p "网站地址:" web_link
read -p "muKey:" mu_key

#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi

#Install Basic Tools
if [[ ${OS} == Ubuntu ]];then
	apt-get update 
	apt-get install build-essential wget -y
	apt-get install openssl
	apt-get install python-dev -y
	apt-get install python-pip -y
	apt-get install git -y
fi
if [[ ${OS} == CentOS ]];then
	yum install update
	yum install python-setuptools -y && easy_install pip -y
	yum install openssl
	yum install git -y
	yum install python-dev -y
    	yum groupinstall "Development Tools" -y
fi
if [[ ${OS} == Debian ]];then
	apt-get update
	apt-get install openssl
	apt-get install python-pip -y
	apt-get install git -y
	apt-get install python-dev -y
    	apt-get install build-essential -y
fi

#install libsodium
wget -N --no-check-certificate https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
ldconfig

#clone shadowsocks
cd /root
git config --global http.sslverify false
git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
cd shadowsocks
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
chmod +x *.sh

#install devel
pip install -r requirements.txt

sed -i "2s/1/${id_name}/g" ${config_file}
sed -i "15s/modwebapi/${api_mode}/g" ${config_file}
sed -i "17s/zhaoj.in/${web_link}/g" ${config_file}
sed -i "18s/glzjin/${mu_key}/g" ${config_file}

iptables -F
/root/shadowsocks/run.sh

# RSA-key
wget -N --no-check-certificate https://raw.githubusercontent.com/4D4937/Others/master/ssh_rsa.sh && bash ssh_rsa.sh

#ali
curl -sSL https://raw.githubusercontent.com/4D4937/ss-script-/master/ali.sh | sudo bash
rm -rf /usr/local/aegis
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service

# serverspeeder
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh

echo enjoy it!
