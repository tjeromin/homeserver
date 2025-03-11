#!/bin/bash

# $1 path to backup folder

printf 'This script will delete and restore the database nextcloud. Is the mariadb docker container running (y/n)? '
read -r answer

if [[ "$answer" != "Y" && "$answer" != "y" ]]; then
    exit
fi

printf '\nIs nextcloud not yet installed or in maintenance mode? (y/n)? '
read -r answer

if [[ "$answer" != "Y" && "$answer" != "y" ]]; then
    exit
fi

printf "\n\n --- restore database ---\n"
read -s -p -r "Enter password:" password
docker exec mariadb sh -c 'mariadb -u root -p'"$password"' -e "DROP DATABASE nextcloud"'
docker exec mariadb sh -c 'mariadb -u root -p'"$password"' -e "CREATE DATABASE nextcloud"'

printf "\nrestoring database dump...\n"
docker exec mariadb sh -c 'mariadb -u root -p"pararas" --database nextcloud < /var/lib/mysql/nextcloud-sqlbkp.sql'
