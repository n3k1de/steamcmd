FROM debian:stretch-slim
MAINTAINER DJustDE <docker@djust.de>

ENV GAME ttt
ENV SERVERDIR /opt/server
ENV STEAMCMDDIR /home/steam

ENV PORT=27015
ENV PORTTV=27020
ENV CLIENTPORT=27005
ENV SPORT=26900
ENV MAXPLAYERS=12
ENV GAMEMODE=terrortown
ENV MAP=gm_construct
ENV SERVERNAME=
ENV PASSWD=
ENV RCONPASSWD=
ENV WORKSHOPCOLLECTION=
ENV APIKEY=
ENV SERVERACCOUNT=

# --> 27015/tcp=Rcon; 27015/udp=information; 27005/udp=client; 27020/udp=SourceTV; 26900/udp=steam
EXPOSE 27015/tcp 27015/udp 27005/udp 27020/udp 26900/udp 51840/udp 80/tcp 443/tcp

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6=8.3.0-6 lib32gcc1=1:8.3.0-6 wget ca-certificates && \
    addgroup --gid 27015 steam && \
    adduser --uid 27015 --ingroup steam --disabled-password --disabled-login steam && \
    chmod 0775 /opt/ && chown steam.steam /opt/ && \
    su steam -c "mkdir -p ${STEAMCMDDIR} ${SERVERDIR} /home/steam/.steam/sdk32/ && \
        cd ${STEAMCMDDIR} && \
        wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -"

WORKDIR ${STEAMCMDDIR}
COPY /data/ /opt/
RUN chmod 0775 /opt/entrypoint.sh && chown steam.steam /opt/entrypoint.sh

USER steam
VOLUME ["${STEAMCMDDIR}", "${SERVERDIR}"]
ENTRYPOINT ["/opt/entrypoint.sh"]
