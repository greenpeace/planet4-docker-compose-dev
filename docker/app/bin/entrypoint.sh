#!/bin/sh

until cd /var/www/html/public/wp-content/plugins ; do
    echo "Wait for project folder mount"
    sleep 5
done

cp /var/www/html/wp-cli.yml.default /var/www/html/wp-cli.yml

su -m -c "sed -i s:db_user:$DBUSER: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:db_pass:$DBPASS: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:wordpress:$DBNAME: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "sed -i s:127.0.0.1:$DBHOST: /var/www/html/wp-cli.yml" -ls /bin/sh nginx &&
su -m -c "cd /var/www/html && composer install && composer run-script docker-site-install && composer run-script site-dev" -ls /bin/sh nginx &&

php-fpm &
nginx -g "daemon off;"
