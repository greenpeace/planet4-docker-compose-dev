#!/usr/bin/env bash

su -m -c "cd /var/www/html && vendor/bin/wp $1" -ls /bin/sh nginx