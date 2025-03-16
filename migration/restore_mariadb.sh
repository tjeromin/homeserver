#!/bin/bash

# $1 path to backup folder

printf 'This script will delete and restore the database nextcloud. Is the mariadb docker container running (yes/n)? '
read -r answer

if [ "$answer" != "yes" ]; then
    exit
fi

printf '\nIs nextcloud not yet installed or in maintenance mode? (yes/n)? '
read -r answer

if [ "$answer" != "yes" ]; then
    exit
fi

printf "\n\n --- restore database ---\n"
read -rsp "Enter password:" password
printf "\n"
if docker exec mariadb sh -c 'mariadb -u root -p'"$password"' -e "DROP DATABASE nextcloud"'; then
    printf "success\n"
else
    printf "failed\n"
    exit 1
fi
if docker exec mariadb sh -c 'mariadb -u root -p'"$password"' -e "CREATE DATABASE nextcloud"'; then
    printf "success\n"
else
    printf "failed\n"
    exit 1
fi

printf "\nrestoring database dump...\n"
if docker exec mariadb sh -c 'mariadb -u root -p"pararas" --database nextcloud < /var/lib/mysql/nextcloud-sqlbkp.sql'; then
    printf "success\n"
else
    printf "failed\n"
    exit 1
fi

printf "\nfinished! Turn off nextcloud maintenance mode\n"
