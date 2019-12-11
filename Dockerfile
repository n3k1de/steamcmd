FROM debian:buster-slim
MAINTAINER DJustDE <docker@djust.de>

ENV GAME ttt
ENV STEAMCMDDIR /home/steam/steamcmd

ENV PORT 27015
ENV MAXPLAYERS 12
ENV GAMEMODE terrortown
ENV MAP gm_construct
ENV SERVERNAME __placeholder__
ENV PASSWD __placeholder__
ENV RCONPASSWD __placeholder__
ENV WORKSHOPCOLLECTION __placeholder__
ENV APIKEY __placeholder__
ENV SERVERACCOUNT __placeholder__

# --> Dedicated or Listen Servers(Steam) (27015/tcp=Rcon; 27015/udp=gameplay)
EXPOSE 27015-27020/tcp 27015-27020/udp

# --> only ARK server
# EXPOSE 7777-7778/tcp 7777-7778/udp
# RUN echo "fs.file-max=100000" >> /etc/sysctl.conf && /
#    echo "* soft nofile 1000000" >> /etc/security/limits.conf && /
#    echo "* hard nofile 1000000" >> /etc/security/limits.conf && /
#    echo "session required pam_limits.so" >> /etc/pam.d/common-session

# ---- >> Server Update
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget ca-certificates curl screen sudo bash
# ---- >> add user, group steam and add home dir
RUN addgroup --gid 1000 steam && \
    adduser --uid 1000 --ingroup steam --no-create-home --disabled-password --disabled-login steam && \
    mkdir -p ${STEAMCMDDIR} && cd ${STEAMCMDDIR} && \
    chmod -R 0775 ${STEAMCMDDIR} && \
    chown steam.steam ${STEAMCMDDIR}
# RUN echo 'steam ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers'

# ---- >> copy start script
COPY /data ${STEAMCMDDIR}
WORKDIR ${STEAMCMDDIR}

# ---- >> Install steam cmd
RUN su steam -c "wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -"
# RUN rm ${STEAMCMDDIR}/steamcmd_linux.tar.gz
# RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit
# RUN ln -s ${STEAMCMDDIR}/linux32/steamclient.so ${STEAMCMDDIR}/.steam/sdk32/steamclient.so
# RUN chown steam.steam ${STEAMCMDDIR}
# RUN chmod -R 0775 ${STEAMCMDDIR}

USER steam
VOLUME ${STEAMCMDDIR}
ENTRYPOINT ["${STEAMCMDDIR}/entrypoint"]
