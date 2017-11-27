#!/bin/bash

#sudo usermod -u $USERID user
id


if [ $WAIT_FOUR_PLUGINS_MOUNT -eq 1 ]; then
    until cd /var/www/html/public/wp-content/plugins ; do
        echo "Wait for project folder mount"
        sleep 5
    done

    declare -a R_ARRAY=($(echo $PLUGINS_REPOS | awk 'BEGIN{FS="__";} {for (i = 1; i <=NF; i++) print $i }'))
    for h in "${R_ARRAY[@]}"; do
        git clone $h
    done
fi

if [ $WAIT_FOUR_PLUGINS_MOUNT -eq 0 ]; then
    rm -rf /var/www/html/public/*
    rm composer.lock
fi


cp /var/www/html/wp-cli.yml.default /var/www/html/wp-cli.yml

sudo sed -i s:localhost:$XDEBUG_REMOTE_HOST: /etc/php/7.0/mods-available/xdebug.ini
sed -i s:db_user:$DBUSER: /var/www/html/wp-cli.yml
sed -i s:db_pass:$DBPASS: /var/www/html/wp-cli.yml
sed -i s:wordpress:$DBNAME: /var/www/html/wp-cli.yml
sed -i s:127.0.0.1:$DBHOST: /var/www/html/wp-cli.yml

cd /var/www/html

# check if dev user already exists and delete it
if [ -f 'vendor/bin/wp' ]; then
    dev_user=( $( cd /var/www/html && vendor/bin/wp user list --field=user_login | grep dev | wc -l ) )
    if [ $dev_user -gt 0 ]; then
        vendor/bin/wp user delete dev --yes
    fi
fi


# if wordpress core already exists do a composers update instead of composer install
if [ ! -d "/var/www/html/public/wp-content" ]; then
  echo -e "Running composer install and docker-site-install";
  composer install && composer docker-site-install
else
  echo -e "Running composer update and docker-site-update";
  composer update && composer docker-site-update
fi


# check if dev user already exists and create it
dev_user=( $( cd /var/www/html && vendor/bin/wp user list --field=user_login | grep dev | wc -l ) )
if [ $dev_user -eq 0 ]; then
    echo -e "Create dev user. \n";
    composer core:add-super-admin-user
fi

# add debug defines to wp-config
grep -q "SAVEQUERIES" /var/www/html/public/wp-config.php || sed -e '1r /wp-config-defines.php' -i /var/www/html/public/wp-config.php

# install and activate useful plugins for development
#wp plugin install debug-bar
#wp plugin activate debug-bar
#wp plugin install query-monitor
#wp plugin activate query-monitor

# start php-fpm
echo "Starting pfp-fpm"
sudo /usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf
