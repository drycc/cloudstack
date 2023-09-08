ARG CODENAME
FROM registry.drycc.cc/drycc/base:${CODENAME}

ARG APT_MIRROR
RUN sed -i -r "s#deb.debian.org#${APT_MIRROR}#g" /etc/apt/sources.list \ 
  && install-packages openssl nfs-kernel-server \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /exports

ADD rootfs /
RUN chmod +rx /entrypoint.sh

VOLUME /exports

EXPOSE 2049/tcp
EXPOSE 20048/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/exports"]
