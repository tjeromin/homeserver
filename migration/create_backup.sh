#!/bin/bash

### NEXTCLOUD

dest=/tmp/nextcloud-dirbkp_$(date +"%Y%m%d")/

printf "\n--- NEXTCLOUD ---\n"

printf "\n--- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/config "$dest"

printf "\n\n --- copy themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/themes "$dest"

printf "\n\n --- backup database ---\n"
read -s -p -r "Enter password:" password
printf "\ncreating database dump...\n"
mysqldump --single-transaction -h localhost -u oc_ncadmin -p"$password" nextcloud >"$dest"/nextcloud-sqlbkp.bak

### IOBROKER

printf "\n--- IOBROKER ---\n"

printf "\n--- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /opt/iobroker "$dest"

printf "\nfinished. Saved backup in %s\n" "$dest"
