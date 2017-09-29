#!/usr/bin/env bash

su -m -c "cd /var/www/html && composer install && composer $* " -ls /bin/bash nginx
