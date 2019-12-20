FROM ubuntu:19.04
MAINTAINER DJustDE <docker@djust.de>

# ENV GAME ttt
# ENV SERVERDIR /opt/server
ENV STEAMCMDDIR /home/steam

# ENV PORT=27015
# ENV PORTTV=27020
# ENV CLIENTPORT=27005
# ENV SPORT=26900
# ENV MAXPLAYERS=12
# ENV GAMEMODE=terrortown
# ENV MAP=gm_construct
# ENV SERVERNAME=
# ENV PASSWD=
# ENV RCONPASSWD=
# ENV WORKSHOPCOLLECTION=
# ENV APIKEY=
# ENV SERVERACCOUNT=

# --> 27015/tcp=Rcon; 27015/udp=information; 27005/udp=client; 27020/udp=SourceTV; 26900/udp=steam
# EXPOSE 27015/tcp 27015/udp 27005/udp 27020/udp 26900/udp 51840/udp 80/tcp 443/tcp

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests locales lib32stdc++6 libstdc++6:i386 lib32gcc1 wget ca-certificates && \
    rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    addgroup --gid 27015 steam && \
    adduser --uid 27015 --ingroup steam --disabled-password --disabled-login steam && \
    chmod 0775 /opt/ && chown steam.steam /opt/ && \
    su steam -c "mkdir -p ${STEAMCMDDIR} ${SERVERDIR} /home/steam/.steam/sdk32/ && \
        cd ${STEAMCMDDIR} && \
        wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" && \
    ulimit -n 2048

ENV LANG en_US.utf8
WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
# COPY /data/ /opt/
# RUN chmod 0775 /opt/entrypoint.sh && chown steam.steam /opt/entrypoint.sh && \
#     su steam -c "${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit"
# 
# USER steam
# VOLUME ["${STEAMCMDDIR}", "${SERVERDIR}"]
# ENTRYPOINT ["/opt/entrypoint.sh"]
