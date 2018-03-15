FROM ubuntu:16.04

ENV PLANET4_BASE_URL https://github.com/greenpeace/planet4-base

USER root

RUN apt-get update && apt-get -y install \
    bash-completion \
    curl \
    git \
    mysql-client \
    libxml2 \
    libxml2-dev \
    rsync \
    nano \
    libmcrypt-dev \
    php \
    php-common \
    php-cli \
    php-curl \
    php-ctype \
    php-calendar \
    php-fileinfo \
    php-ftp \
    php-fpm \
    php-gettext \
    php-gd \
    php-recode \
    php-iconv \
    php-imagick \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-pdo \
    php-redis \
    php-soap \
    php-dev \
    php-xml \
    php-xmlrpc \
    php-zip \
    nginx locales sudo subversion wget

RUN pecl install xdebug-2.5.5

WORKDIR /var/www/html

USER root
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wget -O phpunit https://phar.phpunit.de/phpunit-6.phar && \
    mv phpunit /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit


# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY conf/php/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
RUN chmod 644 /etc/php/7.0/mods-available/xdebug.ini && phpenmod xdebug

COPY conf/php/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY conf/php/php-fpm-pool.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY bin/entrypoint.sh /entrypoint.sh
COPY bin/wp-completion.bash /etc/bash_completion.d/wp
COPY bin/composer-completion.bash /etc/bash_completion.d/composer
COPY conf/wp-config-defines.php/ /wp-config-defines.php

RUN chmod -R 644 /etc/bash_completion.d/* /wp-config-defines.php
RUN chmod 777 -R /tmp && chmod o+t -R /tmp
RUN adduser user && \
    adduser user sudo && \
    echo "user:secret" | chpasswd
RUN chown -R user:user /entrypoint.sh /home/user
RUN echo "user  ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/user"
USER user
ENV PATH="${PATH}:/var/www/html/vendor/bin"

CMD [ "/entrypoint.sh" ]