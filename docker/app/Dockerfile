FROM php:7.1-fpm-alpine

ENV PLANET4_BASE_URL https://github.com/greenpeace/planet4-base

RUN apk --update add \
  git mysql-client rsync nginx subversion bash && \
  docker-php-ext-install mysqli && \
  curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.2.tar.gz &&\
  tar xfz /tmp/redis.tar.gz &&\
  rm -r /tmp/redis.tar.gz &&\
  mkdir -p /usr/src/php/ext && \
  mv phpredis-3.1.2 /usr/src/php/ext/redis &&\
  docker-php-ext-install redis &&\
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/bin/composer && \
  chown nginx:nginx /var/www/html

USER nginx
WORKDIR /var/www/html

USER root
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/site.conf /etc/nginx/conf.d/site.conf
COPY bin/entrypoint.sh /entrypoint.sh
COPY conf/php/php.ini /usr/local/etc/php-fpm.d/php_session.conf

CMD [ "/entrypoint.sh" ]
