#!/bin/bash

apt update -y
apt upgrade -y

echo "################"
echo "install programs"
echo "################"

if smartctl --version; then
    echo "smartmontools already installed"
else
    apt install smartmontools
fi

echo "################"

if python3 --version; then
    echo "python already installed"
else
    apt install python3
fi

echo "################"
echo "copy files"

mkdir -p /var/spool/cron/crontabs
if cp crontab /var/spool/cron/crontabs/root; then
    echo "success"
else 
    echo "failed"
fi

echo "################"
echo "make files executable"
chmod +x ../disk_scripts/measure_influxdb_size.sh
chmod +x ../migration/create_backup.sh
chmod +x ../migration/restore_backup.sh
chmod +x ../migration/restore_mariadb.sh

echo "################"

echo "finished"
echo "Expecting docker and docker-compose to be installed"
echo "check paths in crontab for root"
echo "copy entries in fstab file to /etc/fstab"
