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

RUN addgroup --gid "${GID}" steam && \
    adduser --uid "${UID}" --ingroup "${GROUP}" --disabled-password --disabled-login --gecos "" "${USER}"
RUN ulimit -n "${ULIMIT}"
RUN add-apt-repository multiverse && dpkg --add-architecture i386
RUN apt update && apt install steamcmd
RUN apt-get autoremove -y && \
    apt-get clean  && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR ${STEAMCMDDIR}
VOLUME ${STEAMCMDDIR}
