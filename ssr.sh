#!/bin/bash

#Install pip&git
yum install python-setuptools && easy_install pip
yum install git
#Install libsodium
yum -y groupinstall "Development Tools"
download_files(){
    # Download libsodium file
    if ! wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz; then
        echo "Failed to download libsodium-1.0.12.tar.gz!"
        exit 1
    fi
}	


install(){
    # Install libsodium
    if [ ! -f /usr/lib/libsodium.a ]; then
        cd ${cur_dir}
        tar zxf libsodium-1.0.10.tar.gz
        cd libsodium-1.0.12
        ./configure --prefix=/usr && make && make install
        if [ $? -ne 0 ]; then
            echo "libsodium install failed!"
            install_cleanup
            exit 1
        fi
    fi
    echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
    ldconfig
}	

#clone Shadowsocks 
    if ! git clone -b manyuser https://github.com/glzjin/shadowsocks.git; then
        echo "Failed to clone Shadowsocks file!"
        exit 1
    fi
#Install devel

    cd shadowsocks
    if check_sys packageManager yum; then
        yum -y install python-devel
        yum -y install libffi-devel
        yum -y install openssl-devel
	    pip install -r requirements.txt
	fi

#config
        cp apiconfig.py userapiconfig.py
		cp config.json user-config.json
    

	
