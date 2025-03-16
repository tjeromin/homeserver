#!/bin/bash

### NEXTCLOUD

dest=/tmp/nextcloud-dirbkp_$(date +"%Y%m%d")/
mkdir "$dest"

printf "\n--- NEXTCLOUD ---\n"

printf "\n--- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/config "$dest"

printf "\n\n --- copy themes folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /var/www/html/themes "$dest"

printf "\n\n --- backup database ---\n"
printf "\n backup mariadb db for nextcloud? (yes/no) "
read -r answer

if [ "$answer" == "yes" ]; then
    if mysqldump --single-transaction -h localhost -u root -p nextcloud >"$dest"nextcloud-sqlbkp.sql; then
        printf "\nsuccess\n"
    else
        printf "\nfailed\n"
        exit 1
    fi
fi

### IOBROKER

printf "\n\n--- IOBROKER ---\n"

printf "\n--- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /opt/iobroker "$dest"

### GRAFANA

printf "\n\n--- GRAFANA ---\n"

mkdir "$dest"grafana
mkdir "$dest"grafana/plugins

printf "\n--- copy config folders ---\n"
rsync -Aavx --info=progress2 --info=name0 /etc/grafana/grafana.ini "$dest"grafana/
rsync -Aavx --info=progress2 --info=name0 /etc/grafana/custom.ini "$dest"grafana/
rsync -Aavx --info=progress2 --info=name0 /var/lib/grafana/plugins "$dest"grafana/

printf "\nfinished. Saved backup in %s\n" "$dest"
