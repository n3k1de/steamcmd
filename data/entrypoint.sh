#!/bin/bash
cd ${STEAMCMDDIR}
if [ "$(stat -c %U ${STEAMCMDDIR})" != "steam" ] ; then 
  chown -R steam.steam ${STEAMCMDDIR}
fi;
# wget -O start.sh https://play.djust.de/steamcmd/request/ttt/${HOSTNAME}/start.sh
wget -O start.sh https://raw.githubusercontent.com/djust-de/steamcmd/master/bash/start-gmod.sh
chmod -R 0775 ./start.sh
su steam -c "./start.sh"
