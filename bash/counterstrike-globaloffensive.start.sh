#!/bin/sh

# update
ln -s ${STEAMCMDDIR}/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so
${STEAMCMDDIR}/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous \
+force_install_dir "${SERVERDIR}/csgo/" +app_update 740 validate \
+quit

# server start
cd ${SERVERDIR}/csgo/
./srcds_run \
-game csgo \
-console -nobreakpad -usercon -secure -debug \
-authkey ${APIKEY} \
-port ${PORT} \
-ip $IP \
+port ${PORT} \
+clientport ${CLIENTPORT} \
+maxplayers ${MAXPLAYERS} \
+game_type ${GAME_TYPE} \
+game_mode ${GAME_MODE} \
+mapgroup ${MAPGROUP} \
+map ${MAP} \
+sv_password ${PASSWD} \
+sv_setsteamaccount ${SERVERACCOUNT} \
-exec server.cfg \
-net_port_try 1
