#!/bin/bash

# $1 path to backup folder

printf 'This script will delete and write the config, themes and data folder in /var/www/html/ and delete and restore the database nextcloud (y/n)? '
read -r answer

if [[ "$answer" != "Y" && "$answer" != "y" ]]; then
    exit
fi

printf "\n--- NEXTCLOUD ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 $1/config /var/www/html/config

printf "\n\n --- restore themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 $1/themes /var/www/html/themes

printf "\n\n --- restore database ---\n"
read -s -p -r "Enter password:" password
mysql -h localhost -u oc_ncadmin -p"$password" -e "DROP DATABASE nextcloud"
mysql -h localhost -u oc_ncadmin -p"$password" -e "CREATE DATABASE nextcloud"
printf "\nrestoring database dump...\n"
mysql -h localhost -u oc_ncadmin -p"$password" nextcloud < nextcloud-sqlbkp.bak

printf "\n--- IOBROKER ---\n"

printf "\n--- restore config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 $1/iobroker /opt/iobroker

printf "\nfinished\n"