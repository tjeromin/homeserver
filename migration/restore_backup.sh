#!/bin/bash

# $1 path to backup folder

printf 'This script will delete and write the config, themes and data folder in /var/www/html/ 
 and ./iobroker and ./grafana. The script has to be started from the same directory. Start? (yes/no)? '
read -r answer

if [ "$answer" != "yes" ]; then
    exit
fi

printf "\n--- NEXTCLOUD ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/config ../nextcloud

printf "\n\n --- restore themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/themes ../nextcloud

printf "\n--- IOBROKER ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/iobroker ../iobroker

printf "\n\n--- GRAFANA ---\n"

printf "\n--- copy config folders ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/grafana.ini ../grafana/grafana.ini
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/custom.ini ../grafana/custom.ini
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/plugins ../grafana/var/plugins

printf "\n\nfinished! Start docker-compose and run restore_mariadb.sh to restore the nextcloud database if you want to replace it\n"

