FROM debian:stretch-slim
MAINTAINER DJustDE <docker@djust.de>

ENV GAME=ttt
ENV SERVERACCOUNT=
ENV PORT=27015
ENV MAXPLAYERS=12
ENV SERVERNAME=DJust-GMod-TTT
ENV GAMEMODE=terrortown
ENV MAP=gm_construct
ENV PASSWD=
ENV RCONPASSWD==
ENV WORKSHOPCOLLECTION=
ENV APIKEY=

EXPOSE 26900-26905/udp 27015-27020/tcp 27015-27020/udp

# EXPOSE 7777-7778/tcp 7777-7778/udp
# RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
# RUN echo "* soft nofile 1000000" >> /etc/security/limits.conf
# RUN echo "* hard nofile 1000000" >> /etc/security/limits.conf
# RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget curl ca-certificates screen sudo bash
RUN addgroup --gid 1000 steamcmd
RUN adduser --uid 1000 --ingroup steamcmd --disabled-password --disabled-login steamcmd
# --no-create-home

RUN mkdir -p /data /home/steamcmd /home/steamcmd/.steam/sdk32
RUN chmod -R 0775 /data /home/steamcmd
# RUN echo 'steamcmd ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers'

COPY /data /data
# COPY /data/ping in /data/ping
WORKDIR /data

RUN wget -R /steamcmd https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN chmod -R 0755 steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN rm steamcmd_linux.tar.gz
RUN /data/steamcmd.sh +login anonymous +quit

RUN ln -s /data/linux32/steamclient.so /home/steamcmd/.steam/sdk32/steamclient.so
RUN chown steamcmd.steamcmd /data /home/steamcmd
RUN chmod -R 0775 /data /home/steamcmd
USER steamcmd

VOLUME [/data, /home/steamcmd]
WORKDIR /data
ENTRYPOINT ["/data/entrypoint"]
