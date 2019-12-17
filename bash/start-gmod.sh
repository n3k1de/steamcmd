#!/bin/bash

# update
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
 +force_install_dir "/home/steam/server/gmod/" +app_update 4020 validate \
 +force_install_dir "/home/steam/server/css" +app_update 232330 validate \
 +force_install_dir "/home/steam/server/tf2" +app_update 232250 validate \
 +quit
# ln -s ${SERVERDIR}/linux32/steamclient.so ${SERVERDIR}/.steam/sdk32/steamclient.so
# +force_install_dir "/home/steam/server/css" +app_update 232330 validate \
# +force_install_dir "/home/steam/server/tf2" +app_update 232250 validate \


# edit mount.cfg 
echo "\"mountcfg\"" > "${SERVERDIR}/gmod/garrysmod/cfg/mount.cfg"
echo "{" >> "${SERVERDIR}/gmod/garrysmod/cfg/mount.cfg"
echo "	\"cstrike\"	\"${SERVERDIR}/css/cstrike\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/mount.cfg"
echo "	\"tf\"		\"${SERVERDIR}/tf2/tf\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/mount.cfg"
echo "}" >> "${SERVERDIR}/gmod/garrysmod/cfg/mount.cfg"

# mountdepots.txt
echo "\"gamedepotsystem\"" > "${SERVERDIR}/gmod/garrysmod/cfg/mountdepots.txt"
echo "{" >> "${SERVERDIR}/gmod/garrysmod/cfg/mountdepots.txt"
echo "	\"tf\"			\"1\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/mountdepots.txt"
echo "	\"cstrike\"		\"1\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/mountdepots.txt"
echo "}" >> "${SERVERDIR}/gmod/garrysmod/cfg/mountdepots.txt"


# edit server.cfg
echo "hostname \"${SERVERNAME}\"" > "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_password \"${PASSWD}\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "rcon_password \"${RCONPASSWD}\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
## echo "\"sv_loadingurl\" \"https://play.djust.de\"" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_region 3" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_lan 0" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_pure 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_pausable 0" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "fps_max 120" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "log on" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_logbans 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_logecho 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_logfile 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "sv_log_onefile 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"
echo "lua_log_sv 1" >> "${SERVERDIR}/gmod/garrysmod/cfg/server.cfg"


	# server start
cd ${SERVERDIR}/gmod/
${SERVERDIR}/gmod/srcds_run -game garrysmod -secure +sv_setsteamaccount ${SERVERACCOUNT} -authkey ${APIKEY} +host_workshop_collection ${WORKSHOPCOLLECTION} -port ${PORT} +tv_port ${PORTTV} -clientport ${CLIENTPORT} -sport ${SPORT} +maxplayers ${MAXPLAYERS} +gamemode ${GAMEMODE} +map ${MAP} -tickrate 66 -exec server.cfg
