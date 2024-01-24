FROM ubuntu:jammy-20240111
LABEL version="0.2" maintainer="NetherKids <docker@netherkids.de>"

ARG USER="steam"
ARG GROUP="steam"
ARG UID=27015
ARG GID=27015

ENV USER="${USER}" \
    GROUP="${GROUP}" \
    UID=${UID} \
    GID=${GID} \
    STEAMCMDDIR="/home/steam" \
    SERVERDIR="/opt/server" \
    LANG="en_US.utf8" \
    ULIMIT="2048"

# && apt-get upgrade -y
RUN apt update && apt install -y --no-install-recommends --no-install-suggests locales software-properties-common
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales
RUN dpkg --add-architecture i386
RUN apt-add-repository --component non-free
RUN apt-get update
RUN apt install -y --no-install-recommends --no-install-suggests \
        wget \
        curl \
        ca-certificates \
        gdb \
        python3 python3-requests
# RUN apt install -y --no-install-recommends --no-install-suggests libstdc++6 libc6-i386 lib32ncurses5
RUN apt install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        lib32gcc-s1
RUN addgroup --gid "${GID}" steam && \
    adduser --uid "${UID}" --ingroup "${GROUP}" --disabled-password --gecos "" "${USER}" && \
    chmod 0775 /opt/ && chown steam.steam /opt/

RUN mkdir -p -m 0755 ${STEAMCMDDIR} && chown "${USER}" ${STEAMCMDDIR}

RUN su "${USER}" -c "curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C ${STEAMCMDDIR}"
RUN su "${USER}" -c "${STEAMCMDDIR}/steamcmd.sh +quit"
RUN su "${USER}" -c "ln -s ${STEAMCMDDIR}/linux32/steamclient.so ${STEAMCMDDIR}/steamservice.so"
RUN su "${USER}" -c "mkdir -p ~/.steam/sdk32 && ln -s ${STEAMCMDDIR}/linux32/steamclient.so ~/.steam/sdk32/steamclient.so"
RUN su "${USER}" -c "mkdir -p ~/.steam/sdk64 && ln -s ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so"

RUN ulimit -n "${ULIMIT}"
RUN apt-get autoremove -y --purge wget && \
    apt-get clean  && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
