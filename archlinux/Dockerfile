FROM archlinux
MAINTAINER NetherKids <git@netherkids.de>

ENV STEAMCMDDIR=/home/steam

RUN git clone https://aur.archlinux.org/steamcmd.git && \
  cd steamcmd && \
  makepkg -si

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
ENTRYPOINT ["/home/steam/steamcmd.sh"]
