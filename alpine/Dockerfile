LABEL version="0.2.1" \
    maintainer="NetherKids <docker@netherkids.de>"

ARG DOWNLOADSTEAM="https://media.steampowered.com/installer/steamcmd_linux.tar.gz"

ENV USER="steam" \
    GROUP="steam" \
    UID=27015 \
    GID=27015 \
    STEAMCMDDIR="/var/${USER}" \
    SERVERDIR="${STEAMCMDDIR}/server" \
    LANG="en_US.utf8" \
    LANGUAGE 'en_US:en' \
    ULIMIT="2048"

# temp image
FROM ubuntu:focal as tempimg
RUN dpkg --add-architecture i386; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates curl tar locales steamcmd; \
    mkdir /root/steamcmd; \
    curl -qO- ${DOWNLOADSTEAM} | tar -xzf -C /root/steamcmd

# main image
FROM alpine:3.12

RUN apk add --no-cache ca-certificates libstdc++ su-exec libpq python3 py3-pip; \
    rm -rf /var/cache/apk/*
RUN set -eux; \
    addgroup -g ${GID} ${GROUP}; \
    adduser -u ${UID} -Hh /var/${USER} -G ${GROUP} -s /sbin/nologin -D ${USER}; \
    install -d -o ${USER} -g ${GROUP} -m 775 ${STEAMCMDDIR}

COPY --from=tempimg /root/steamcmd/ ${STEAMCMDDIR}
COPY --from=tempimg /usr/games/steamcmd /usr/bin/steamcmd

COPY --from=tempimg /etc/ssl/certs /etc/ssl/certs
COPY --from=tempimg /lib/i386-linux-gnu /lib/
COPY --from=tempimg /root/installer/linux32/libstdc++.so.6 /lib/

RUN steamcmd +quit

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
