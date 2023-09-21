#!/usr/bin/env bash
AGENT_ADDRESS=${AGENT_ADDRESS:?"environment is required"}
AGENT_GATEWAY=${AGENT_GATEWAY:?"environment is required"}
AGENT_NAMESERVERS=${AGENT_NAMESERVERS:?"environment is required"}
AGENT_NETWORK_DEVICE=${AGENT_NETWORK_DEVICE:?"environment is required"}


function apply_network(){
  if [[ -d /etc/cloud/cloud.cfg.d ]]; then
    cat << EOF > "/etc/cloud/cloud.cfg.d/01_network.cfg"
network:
  config: disabled
EOF
  fi

  rm -rf "/etc/netplan/*"
  cat << EOF > "/etc/netplan/01-netcfg.yaml"
network:
  version: 2
  renderer: networkd
  ethernets:
    ${AGENT_NETWORK_DEVICE}:
      dhcp4: false
      dhcp6: false
      optional: true
  bridges:
    cloudbr0:
      addresses: [${AGENT_ADDRESS}]
      routes:
       - to: default
         via: ${AGENT_GATEWAY}
      nameservers:
        addresses: [${AGENT_NAMESERVERS}]
      interfaces: [${AGENT_NETWORK_DEVICE}]
      dhcp4: false
      dhcp6: false
      parameters:
        stp: false
        forward-delay: 0
EOF
  netplan generate
  netplan apply
}

function install_agent(){
  apt install chrony htop lynx duf bridge-utils -y --no-install-recommends
  apt install openssh-server vim htop tar intel-microcode -y --no-install-recommends
  
  systemctl enable serial-getty@ttyS0.service
  systemctl start serial-getty@ttyS0.service
  
  mkdir -p /etc/apt/keyrings
  wget -O- https://download.cloudstack.org/release.asc | gpg --dearmor | tee /etc/apt/keyrings/cloudstack.gpg > /dev/null
  major=$(echo ${CLOUDSTACK_VERSION} | awk -F '.' '{print $1"."$2}')
  echo "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/cloudstack.gpg] \
      http://drycc-mirrors.drycc.cc/cloudstack/ubuntu $(lsb_release -cs) ${major}" > /etc/apt/sources.list.d/cloudstack.list
  
  apt update
  apt install uuid cloudstack-agent qemu-kvm -y --no-install-recommends
}

function configure(){
  cat << EOF > "/etc/sysctl.conf"
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
net.bridge.bridge-nf-call-arptables = 0
net.bridge.bridge-nf-call-iptables = 0
EOF
  sysctl -p

  cat << EOF > "/etc/default/libvirtd"
LIBVIRTD_ARGS="--listen"
EOF
  cat << EOF > "/etc/libvirt/qemu.conf"
vnc_listen = "0.0.0.0"
EOF
  cat << EOF > "/etc/libvirt/libvirtd.conf"
listen_tls=0
listen_tcp=1
tcp_port = "16509"
mdns_adv = 0
auth_tcp = "none"
host_uuid = "$(uuid)"
EOF
  systemctl mask libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket libvirtd-tls.socket libvirtd-tcp.socket
  systemctl restart libvirtd
}

apply_network
install_agent
configure
