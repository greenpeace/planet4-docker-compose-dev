#!/usr/bin/env bash

su -m -c "cd /var/www/html && vendor/bin/wp $* " -ls /bin/sh nginx