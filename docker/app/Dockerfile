FROM php:7.1-fpm-alpine

ENV PLANET4_BASE_URL https://github.com/greenpeace/planet4-base

RUN apk --update add \
    git mysql-client rsync nginx subversion bash sudo \
    busybox-suid nano libmcrypt-dev libltdl mysql-client \
    libxml2 libxml2-dev curl curl-dev libpng libpng-dev freetype-dev libjpeg-turbo-dev  && \
  curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.2.tar.gz &&\
  tar xfz /tmp/redis.tar.gz &&\
  rm -r /tmp/redis.tar.gz &&\
  mkdir -p /usr/src/php/ext && \
  mv phpredis-3.1.2 /usr/src/php/ext/redis

RUN docker-php-ext-configure \
        gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir
RUN  docker-php-ext-install mcrypt mysqli json gd \
    session \
    simplexml \
    dom \
    mbstring \
    zip \
    pdo \
    pdo_mysql \
    redis

RUN  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/bin/composer && \
  chown nginx:nginx /var/www/html && \
  echo http://nl.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
  rm -rf /var/cache/apk/*  && \
  rm -rf /tmp/*

USER nginx
WORKDIR /var/www/html

USER root

COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/site.conf /etc/nginx/conf.d/site.conf
COPY bin/entrypoint.sh /entrypoint.sh
COPY bin/cu.sh /usr/bin/cu
COPY bin/c.sh /usr/bin/c
COPY bin/wp.sh /usr/bin/wp
RUN chmod +x /usr/bin/c* /usr/bin/wp
COPY conf/php/php.ini /usr/local/etc/php-fpm.d/php_session.conf

CMD [ "/entrypoint.sh" ]
