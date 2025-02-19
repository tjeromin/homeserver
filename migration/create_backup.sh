#!/bin/bash

dest=/tmp/nextcloud-dirbkp_$(date +"%Y%m%d")/

printf " --- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/config "$dest"

printf "\n\n --- copy themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/themes "$dest"

printf "\n\n --- backup database ---\n"
read -s -p -r "Enter password:" password
printf "\ncreating database dump...\n"
mysqldump --single-transaction -h localhost -u oc_ncadmin -p"$password" nextcloud >/tmp/nextcloud-dirbkp_$(date +"%Y%m%d")/nextcloud-sqlbkp.bak
