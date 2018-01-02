#!/usr/bin/env bash
clear

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

# serverspeeder
wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh

# RSA-key
wget -N --no-check-certificate https://raw.githubusercontent.com/4D4937/Others/master/ssh_rsa.sh && bash ssh_rsa.sh

# config
read -p "节点ID:" id_name
read -p "网站地址:" web_link
read -p "muKey:" mu_key

	
				
install_soft_for_each(){
	    check_sys
	    if [[ ${release} = "centos" ]]; then
		        yum install git -y
		        yum install python-setuptools -y && easy_install pip
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
yum -y install libssl-dev
yum -y install epel-release
yum -y install python-pip
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel
pip install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json

sed -i "2s/1/${id_name}/g" ${config_file}
sed -i "17s/zhaoj.in/${web_link}/g" ${config_file}
sed -i "18s/glzjin/${mu_key}/g" ${config_file}
iptables -F
/root/shadowsocks/logrun.sh

#update time
yum install -y ntpdate
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
echo "0-59/10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" > /etc/crontab 

#ali
curl -sSL https://raw.githubusercontent.com/4D4937/ss-script-/master/ali.sh | sudo bash
rm -rf /usr/local/aegis
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service

echo enjoy it!
