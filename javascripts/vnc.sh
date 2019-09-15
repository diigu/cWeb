#!/bin/bash
#Check PWGen is installed?
if [ ! -f "/usr/bin/pwgen" ]; then
    echo "PWGen Not Installed, install it."
    sudo apt update > /dev/null 2>&1
    sudo apt install -y pwgen
    echo "PWGen Installed Success"
fi
#Generate Password
SSPASSWORD=`pwgen 15 1`
VNCPASSWORD=`pwgen 8 1`
HTTPPASSWORD=`pwgen 8 1`
RANDOMPORT=$[ $RANDOM % 1000 + 6000 ]
MYIP=`curl ifconfig.me`

if [ -f "/usr/bin/docker" ]; then
    echo "Docker installed, starting VNC..."
else
    echo "Docker not install, ready to instal..."
    sudo apt-get install -y    apt-transport-https    ca-certificates    curl    gnupg2    software-properties-common  > /dev/null 2>&1
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository   "deb [arch=amd64] https://download.docker.com/linux/debian   $(lsb_release -cs)   stable"
    sudo apt-get update > /dev/null 2>&1
    echo "Apt updated, install Docker-ce"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io  > /dev/null 2>&1
    echo "Docker-ce installed, pulling VNC Container"
    sudo docker pull dorowu/ubuntu-desktop-lxde-vnc
    mkdir -p /tmp/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/ssl/nginx.key -out /tmp/ssl/nginx.crt -subj "/C=US/ST=US/L=US/O=D/CN=US"
fi


sudo docker run -p 0.0.0.0:$RANDOMPORT:443 -e SSL_PORT=443 -e VNC_PASSWORD=$VNCPASSWORD -e HTTP_PASSWORD=$HTTPPASSWORD -v /tmp/ssl:/etc/nginx/ssl -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc  > /dev/null 2>&1 &

echo 'HTTP IP https://'$MYIP":$RANDOMPORT/"

echo 'Vnc Password '$VNCPASSWORD

echo 'Http Password '$HTTPPASSWORD


#ss-server -s "0.0.0.0" -p 445 -l 1080 -m "aes-128-cfb" -k "$SSPASSWORD" > /dev/null 2>&1 & 
#echo 'Shadowsocks password '$SSPASSWORD
