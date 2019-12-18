#!/bin/bash

# update
${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit
ln -s /home/steam/.steam/sdk32/steamclient.so ${STEAMCMDDIR}/linux32/steamclient.so 
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
 +force_install_dir "${SERVERDIR}/gmod/" +app_update 4020 -validate \
 +quit

# +force_install_dir "${SERVERDIR}/css" +app_update 232330 -validate \
# +force_install_dir "${SERVERDIR}/tf2" +app_update 232250 -validate \

# server start
cd ${SERVERDIR}/gmod/
ls
./srcds_run -condebug -game garrysmod -secure +sv_lan 0 +sv_setsteamaccount ${SERVERACCOUNT} -authkey ${APIKEY} +host_workshop_collection ${WORKSHOPCOLLECTION} +port ${PORT} +tv_port ${PORTTV} +clientport ${CLIENTPORT} +maxplayers ${MAXPLAYERS} +gamemode ${GAMEMODE} +map ${MAP} -tickrate 66 -exec server.cfg
