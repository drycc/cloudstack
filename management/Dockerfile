FROM ubuntu:22.04

ENV CLOUDSTACK_VERSION 4.18

RUN apt-get update -qq \
  && apt-get install lsb-core curl gpg -y --no-install-recommends \
  && curl -fsSL http://download.cloudstack.org/release.asc | gpg --dearmor -o /etc/apt/keyrings/cloudstack.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/cloudstack.gpg] \
    http://download.cloudstack.org/ubuntu $(lsb_release -cs) ${CLOUDSTACK_VERSION}" > /etc/apt/sources.list.d/cloudstack.list \
  && apt-get update -qq \
  && apt-get install cloudstack-management -y --no-install-recommends

ADD rootfs /

WORKDIR /var/log/cloudstack/management

CMD /usr/local/bin/boot
