FROM debian:stretch-slim
MAINTAINER DJustDE

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
RUN adduser --gid 1000 --uid 1000 --home /home/steamcmd --disabled-password --disabled-login steamcmd

COPY file:81dae9d97304f18c757f25401a3e2f4531c9bcae3c76f515736d8f082e899aaa in /home/steamcmd/run
COPY file:c150eff0f21de316a09f05e53bc6b22e98f5f76b78ddf77ff694c93ef1ea424f in /home/steamcmd/ping

RUN mkdir /steamapps
RUN chown steamcmd /steamapps /home/steamcmd
RUN chmod -R 0755 /steamapps /home/steamcmd
RUN echo 'steamcmd ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers'

USER steamcmd
WORKDIR /home/steamcmd

RUN wget -R /home/steamcmd/ https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN rm steamcmd_linux.tar.gz
RUN /home/steamcmd/steamcmd.sh +login anonymous +quit
RUN mkdir ~/.steam/sdk32 && ln -s /home/steamcmd/linux32/steamclient.so ~/.steam/sdk32/steamclient.so

VOLUME [/steamapps /home/steamcmd]
WORKDIR /home/steamcmd
CMD ["/bin/sh" "-c" "/home/steamcmd/run"]
