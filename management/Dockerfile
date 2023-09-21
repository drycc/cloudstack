ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ENV CLOUD_GID=1001 \
  CLOUD_UID=1001 \
  CLOUDSTACK_DOWNLOAD_URL=https://drycc-mirrors.drycc.cc/cloudstack

RUN groupadd cloud --gid ${CLOUD_GID} \
  && useradd cloud -u ${CLOUD_UID} -g ${CLOUD_GID} -s /bin/bash -m -d /var/lib/cloudstack

ARG APT_MIRROR
ARG CLOUDSTACK_VERSION
ENV CLOUDSTACK_VERSION ${CLOUDSTACK_VERSION}
RUN sed -i -E "s#[a-z]{1,}.ubuntu.com#${APT_MIRROR}#g" /etc/apt/sources.list \ 
  && apt-get update \
  && apt-get install wget lsb-core curl gpg -y \
  && curl -fsSL ${CLOUDSTACK_DOWNLOAD_URL}/release.asc | gpg --dearmor -o /etc/apt/keyrings/cloudstack.gpg \
  && major=$(echo ${CLOUDSTACK_VERSION} | awk -F '.' '{print $1"."$2}') \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/cloudstack.gpg] ${CLOUDSTACK_DOWNLOAD_URL}/ubuntu $(lsb_release -cs) ${major}" \
    > /etc/apt/sources.list.d/cloudstack.list \
  && apt-get update \
  && apt-get install netcat gosu cloudstack-management ssh-client -y

ADD rootfs /

CMD /usr/local/bin/boot
