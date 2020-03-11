FROM debian:stretch-slim
MAINTAINER NetherKids <docker@netherkids.de>

ENV STEAMCMDDIR="/home/steam" \
    SERVERDIR="/opt/server" \
    LANG="en_US.utf8"

COPY --chown=steam:steam /healthcheck.py /

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests locales libstdc++6 libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 wget curl ca-certificates gdb python3 && \
    rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    addgroup --gid 27015 steam && \
    adduser --uid 27015 --ingroup steam --disabled-password --disabled-login --gecos "" steam && \
    chmod 0775 /opt/ && chown steam.steam /opt/ && \
    su steam -c "mkdir -p ${STEAMCMDDIR} ~/.steam/sdk32/ && \
        cd ${STEAMCMDDIR} && \
        wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" && \
    ulimit -n 2048 && \
    apt-get autoremove -y --purge wget && \
    apt-get clean  && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
