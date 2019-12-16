#!/bin/bash
ulimit -n 2048
cd /home/steam/steamcmd
if [ "$(stat -c %U /home/steam/steamcmd)" != "steam" ] ; then 
  chown -R steam.steam /home/steam/steamcmd /home/steam/server
  chmod -v 755 /home/steam/steamcmd /home/steam/server
fi;
# wget -O start.sh https://play.djust.de/steamcmd/request/ttt/${HOSTNAME}/start.sh
wget -O start.sh https://raw.githubusercontent.com/djust-de/steamcmd/master/bash/start-gmod.sh
chmod -R 0775 ./start.sh
su steam -c "./start.sh"
