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
RUN apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget curl ca-certificates screen sudo
RUN addgroup --gid 1000 steamcmd
RUN adduser --uid 1000 --ingroup steamcmd --no-create-home --disabled-password --disabled-login steamcmd

RUN mkdir /data /data/steamcmd
RUN chown steamcmd /data
RUN chmod -R 0755 /data
# RUN echo 'steamcmd ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers'

COPY /data /data
# COPY /data/ping in /data/ping

USER steamcmd
WORKDIR /data/steamcmd/

RUN wget -R /data/steamcmd/ https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN rm steamcmd_linux.tar.gz
RUN /data/steamcmd/steamcmd.sh +login anonymous +quit
RUN mkdir ~/.steam/sdk32 && ln -s /data/steamcmd/linux32/steamclient.so ~/.steam/sdk32/steamclient.so

VOLUME /data
WORKDIR /data
CMD ["/bin/sh" "-c" "/data/run"]
