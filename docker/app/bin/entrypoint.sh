#!/bin/bash

usermod -u $USERID nginx

until cd /var/www/html/public/wp-content/plugins ; do
    echo "Wait for project folder mount"
    sleep 5
done

declare -a R_ARRAY=($(echo $PLUGINS_REPOS | awk 'BEGIN{FS="__";} {for (i = 1; i <=NF; i++) print $i }'))
for h in "${R_ARRAY[@]}"; do
    git clone $h
done

resize -s 30 120

cp /var/www/html/wp-cli.yml.default /var/www/html/wp-cli.yml

su -m -c "sed -i s:db_user:$DBUSER: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:db_pass:$DBPASS: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:wordpress:$DBNAME: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:127.0.0.1:$DBHOST: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&

# check if dev user already exists and delete it
dev_user=( $( su -m -c "cd /var/www/html && vendor/bin/wp user list --field=user_login" -ls /bin/sh nginx | grep dev | wc -l ) )
if [ $dev_user -gt 0 ]; then
    su -m -c "cd /var/www/html && vendor/bin/wp user delete dev --yes " -ls /bin/sh nginx
fi


# if wordpress core already exists do a composers update instead of composer install
if [ ! -d "/var/www/html/public/wp-content" ]; then
  echo -e "Running composer install and docker-site-install.\n";
  su -m -c "cd /var/www/html && composer install && composer run-script docker-site-install" -ls /bin/sh nginx;
else
  echo -e "Running composer update and docker-site-update.\n";
  su -m -c "cd /var/www/html && composer update && composer run-script docker-site-update" -ls /bin/sh nginx
fi


# check if dev user already exists and create it
dev_user=( $( su -m -c "cd /var/www/html && vendor/bin/wp user list --field=user_login" -ls /bin/sh nginx | grep dev | wc -l ) )
if [ $dev_user -eq 0 ]; then
    echo -e "Create dev user. \n";
    su -m -c "cd /var/www/html && composer run-script core:add-super-admin-user" -ls /bin/sh nginx
fi


php-fpm &
nginx -g "daemon off;"
