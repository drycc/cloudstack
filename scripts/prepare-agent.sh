#!/usr/bin/env bash

apt install htop lynx duf bridge-utils -y --no-install-recommends
apt install openntpd openssh-server vim htop tar intel-microcode -y --no-install-recommends

systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service

mkdir -p /etc/apt/keyrings
wget -O- https://download.cloudstack.org/release.asc | gpg --dearmor | tee /etc/apt/keyrings/cloudstack.gpg > /dev/null
major=$(echo ${CLOUDSTACK_VERSION} | awk -F '.' '{print $1"."$2}')
echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/cloudstack.gpg] \
    http://drycc-mirrors.drycc.cc/cloudstack/ubuntu $(lsb_release -cs) ${major}" > /etc/apt/sources.list.d/cloudstack.list

apt update
apt install cloudstack-agent qemu-kvm -y --no-install-recommends
