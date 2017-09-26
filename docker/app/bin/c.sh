#!/usr/bin/env bash

su -m -c "cd /var/www/html && composer install && composer $1" -ls /bin/sh nginx