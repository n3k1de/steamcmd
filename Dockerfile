FROM debian:buster-slim
MAINTAINER DJustDE <docker@djust.de>

ENV GAME ttt
ENV SERVERACCOUNT 
ENV PORT 27015
ENV MAXPLAYERS 12
ENV SERVERNAME DJust-GMod-TTT
ENV GAMEMODE terrortown
ENV MAP gm_construct
ENV PASSWD
ENV RCONPASSWD
ENV WORKSHOPCOLLECTION
ENV APIKEY
ENV STEAMCMDDIR /home/steam/steamcmd

# Dedicated or Listen Servers(Steam) (tcp=Rcon; udp=gameplay)
EXPOSE 27015/tcp 27015/udp

#only ARK server
# EXPOSE 7777-7778/tcp 7777-7778/udp
# RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
# RUN echo "* soft nofile 1000000" >> /etc/security/limits.conf
# RUN echo "* hard nofile 1000000" >> /etc/security/limits.conf
# RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session

# Server Update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget ca-certificates curl screen sudo bash
# add user and group steamcmd
RUN addgroup --gid 1000 steam
RUN adduser --uid 1000 --ingroup steamcmd --no-create-home --disabled-password --disabled-login steam
# --no-create-home

# create dir for steamcmd and data
# RUN mkdir -p ${STEAMCMDDIR}
# RUN chmod -R 0775 ${STEAMCMDDIR}
# RUN echo 'steamcmd ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers'

# copy start script
COPY /data ${STEAMCMDDIR}
WORKDIR ${STEAMCMDDIR}

# Install steam cmd
RUN su steam -c "wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -"
# RUN rm ${STEAMCMDDIR}/steamcmd_linux.tar.gz
# RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit
# RUN ln -s ${STEAMCMDDIR}/linux32/steamclient.so ${STEAMCMDDIR}/.steam/sdk32/steamclient.so
# RUN chown steamcmd.steamcmd ${STEAMCMDDIR}
# RUN chmod -R 0775 ${STEAMCMDDIR}
USER steam

VOLUME ${STEAMCMDDIR}
WORKDIR ${STEAMCMDDIR}
ENTRYPOINT ["${STEAMCMDDIR}/entrypoint"]
