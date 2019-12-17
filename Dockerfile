FROM debian:buster-slim
MAINTAINER DJustDE <docker@djust.de>

ENV GAME ttt
ENV SERVERDIR /home/steam/server
ENV STEAMCMDDIR /home/steam/steamcmd

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
EXPOSE 27015/tcp 27015/udp 27005/udp 27020/udp 26900/udp 51840/udp
# --no-create-home
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget ca-certificates && \
    addgroup --gid 1000 steam && \
    adduser --uid 1000 --ingroup steam --disabled-password --disabled-login steam && \
    su steam -c "mkdir -p ${STEAMCMDDIR} ${SERVERDIR} && \
        cd ${STEAMCMDDIR} && \
        wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -"

WORKDIR ${STEAMCMDDIR}
COPY /data/ /home/steam/
RUN chmod 0775 /home/steam/entrypoint.sh && chown steam.steam /home/steam/entrypoint.sh

USER steam
VOLUME ["/home/steam/steamcmd", "/home/steam/server"]
ENTRYPOINT ["/home/steam/entrypoint.sh"]
