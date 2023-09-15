#!/usr/bin/env bash

apt install htop lynx duf bridge-utils openntpd openssh-server sudo vim htop tar intel-microcode -y

systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service

major=$(echo ${CLOUDSTACK_VERSION} | awk -F '.' '{print $1"."$2}')
echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/cloudstack.gpg] \
    http://drycc-mirrors.drycc.cc/cloudstack/ubuntu $(lsb_release -cs) ${major}" > /etc/apt/sources.list.d/cloudstack.list

apt update
apt install cloudstack-agent qemu-kvm -y
