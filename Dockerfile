FROM php:7.2-apache
MAINTAINER Lucas Ehlinger <lucas.ehlinger@gmail.com>

RUN apt update

# Install openssl
RUN apt install -y --no-install-recommends \
    openssl
# Install pdo_mysql
RUN docker-php-ext-install pdo_mysql
# Install mbstring
RUN docker-php-ext-install mbstring
# Install tokenizer
RUN docker-php-ext-install tokenizer
# Install xml
RUN apt install -y --no-install-recommends \
    libxml2-dev \
    && docker-php-ext-install xml
# Install inconv
RUN docker-php-ext-install iconv
# enable rewrite mod
RUN a2enmod rewrite

# Install composer
# https://hub.docker.com/r/composer/composer/~/dockerfile/
# https://getcomposer.org/doc/00-intro.md
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --install-dir=/bin --filename=composer \
    && rm /tmp/composer-setup.php

RUN sed -ri -e 's!/var/www/html!/home/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/home/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN DEPENDENCIES="git \
    zip \
    unzip \
    openssh-client"\
    && apt-get update && apt-get install -y \
    $DEPENDENCIES \
    && exit $RESULT

WORKDIR /home
