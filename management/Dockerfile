ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG APT_MIRROR
ARG CLOUDSTACK_VERSION
ENV CLOUDSTACK_VERSION ${CLOUDSTACK_VERSION}
RUN sed -i "s#archive.ubuntu.com#${APT_MIRROR}#g" /etc/apt/sources.list \ 
  && apt-get update -qq \
  && apt-get install wget lsb-core curl gpg -y --no-install-recommends \
  && curl -fsSL http://download.cloudstack.org/release.asc | gpg --dearmor -o /etc/apt/keyrings/cloudstack.gpg \
  && MAJOR=$(echo ${CLOUDSTACK_VERSION} | awk -F '.' '{print $1"."$2}') \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/cloudstack.gpg] http://drycc-mirrors.drycc.cc/cloudstack/ubuntu $(lsb_release -cs) ${MAJOR}" \
    > /etc/apt/sources.list.d/cloudstack.list \
  && apt-get update -qq \
  && apt-get install cloudstack-management -y --no-install-recommends

ADD rootfs /

WORKDIR /var/log/cloudstack/management

CMD /usr/local/bin/boot
