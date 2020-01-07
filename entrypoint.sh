#!/bin/sh

ulimit -n 2048‬
cd ${STEAMCMDDIR}

if [ -e "/home/steam/.steam/sdk32/steamclient.so" ]
then
  echo "steamclient.so found."
else
  echo "steamclient.so not found."
  su steam -c "ln -s ${STEAMCMDDIR}/linux32/steamclient.so ~/.steam/sdk32/steamclient.so"
  if [ -e "/home/steam/.steam/sdk32/steamclient.so" ]
  then
    echo "steamclient.so link created."
  fi
fi

# update
${STEAMCMDDIR}/steamcmd.sh \
  +login anonymous \
  +force_install_dir ${SERVERDIR} \
  +app_update ${GAMEID} validate \
  +quit

# server start
cd ${SERVERDIR}/
${SERVER_DIR}/srcds_run \
-game ${GAME_NAME} \
+port ${PORT} \
${GAME_PARAMS}
