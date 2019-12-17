#!/bin/bash

# update
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
 +force_install_dir "${SERVERDIR}/gmod/" +app_update 4020 validate \
 +force_install_dir "${SERVERDIR}/css" +app_update 232330 validate \
 +force_install_dir "${SERVERDIR}/tf2" +app_update 232250 validate \
 +quit

# server start
cd ${SERVERDIR}/gmod/
$./srcds_run -game garrysmod -secure +sv_setsteamaccount ${SERVERACCOUNT} -authkey ${APIKEY} +host_workshop_collection ${WORKSHOPCOLLECTION} -port ${PORT} +tv_port ${PORTTV} -clientport ${CLIENTPORT} -sport ${SPORT} +maxplayers ${MAXPLAYERS} +gamemode ${GAMEMODE} +map ${MAP} -tickrate 66 -exec server.cfg
