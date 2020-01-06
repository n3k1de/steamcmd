FROM archlinux
MAINTAINER NetherKids <git@netherkids.de>

ENV STEAMCMDDIR=/home/steam

RUN addgroup --gid 27015 steam && \
    adduser --uid 27015 --ingroup steam --disabled-password --disabled-login --gecos "" steam && \
    chmod 0775 /opt/ && chown steam.steam /opt/ && \
    git clone https://aur.archlinux.org/steamcmd.git && \
    cd steamcmd && \
    makepkg -si

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
ENTRYPOINT ["/home/steam/steamcmd.sh"]
