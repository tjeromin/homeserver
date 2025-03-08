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
if mysqldump --single-transaction -h localhost -u root -p nextcloud >"$dest"nextcloud-sqlbkp.bak; then
    printf "success\n"
else
    printf "failed\n"
    exit 1
fi

### IOBROKER

printf "\n\n--- IOBROKER ---\n"

printf "\n--- copy config folder ---\n"
rsync -Aavx --info=progress2 --info=name0 /opt/iobroker "$dest"

### INFLUXDB

printf "\n\n--- INFLUXDB ---\n"

mkdir "$dest"influxdb

for bucketid in 1cf0b7166b8afb55 3bf9e01c0e3e7948 c5c943d0ed2227c5 976beebc3c0d1e0a a39b44ee0d3a4e51 cf8589131fc30263; do
    if influxd inspect export-lp \
        --bucket-id $bucketid \
        --engine-path /mnt/drive1/influxdb/engine \
        --output-path "$dest"influxdb/$bucketid.lp \
        --compress; then
        printf "success\n"
    else
        printf "failed\n"
        exit 1
    fi
done

### GRAFANA

printf "\n\n--- GRAFANA ---\n"

mkdir "$dest"grafana
mkdir "$dest"grafana/plugins

printf "\n--- copy config folders ---\n"
rsync -Aavx --info=progress2 --info=name0 /etc/grafana/grafana.ini "$dest"grafana/
rsync -Aavx --info=progress2 --info=name0 /etc/grafana/custom.ini "$dest"grafana/
rsync -Aavx --info=progress2 --info=name0 /var/lib/grafana/plugins "$dest"grafana/

printf "\nfinished. Saved backup in %s\n" "$dest"
