#!/bin/bash
# ulimit -n 2048
cd ${STEAMCMDDIR}

# wget -O start.sh https://play.djust.de/steamcmd/request/ttt/${HOSTNAME}/start.sh
wget -O start.sh https://raw.githubusercontent.com/djust-de/steamcmd/master/bash/start-gmod.sh
chmod -R 0755 ./start.sh
./start.sh
