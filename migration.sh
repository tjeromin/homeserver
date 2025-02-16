# copy config folder
rsync -Aavx --info=progress2 --info=name0 /var/www/html/config /tmp/nextcloud-dirbkp_`date +"%Y%m%d"`/
# copy themes folder
rsync -Aavx --info=progress2 --info=name0 /var/www/html/themes /tmp/nextcloud-dirbkp_`date +"%Y%m%d"`/
