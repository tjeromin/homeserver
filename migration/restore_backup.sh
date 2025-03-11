#!/bin/bash

# $1 path to backup folder

printf 'This script will delete and write the config, themes and data folder in /var/www/html/ (y/n)? '
read -r answer

if [[ "$answer" != "Y" && "$answer" != "y" ]]; then
    exit
fi

printf "\n--- NEXTCLOUD ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/config /var/www/html/config

printf "\n\n --- restore themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/themes /var/www/html/themes

printf "\n--- IOBROKER ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/iobroker /opt/iobroker

printf "\n\n--- GRAFANA ---\n"

printf "\n--- copy config folders ---\n"
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/grafana.ini /etc/grafana/grafana.ini
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/custom.ini /etc/grafana/custom.ini
rsync -Aavx --info=progress2 --info=name0 "$1"/grafana/plugins /var/lib/grafana/plugins

printf "\n\nfinished! Start docker-compose and run restore_mariadb.sh to restore the nextcloud database\n"

