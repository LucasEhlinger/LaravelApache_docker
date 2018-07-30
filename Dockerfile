FROM php:7.1-apache
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

# Install mcrypt
RUN apt install -y --no-install-recommends \
        libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) \
        mcrypt

# Install gd
RUN apt install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

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

RUN BUILD_DEPENDENCIES="autoconf" \
    DEV_DEPENDENCIES="libcurl4-gnutls-dev \
     	    libicu-dev \
     	    libmcrypt-dev \
     	    libvpx-dev \
     	    libjpeg-dev \
     	    libxpm-dev \
     	    zlib1g-dev \
     	    libfreetype6-dev \
     	    libxml2-dev \
     	    libexpat1-dev \
     	    libbz2-dev \
     	    libgmp3-dev \
     	    libldap2-dev \
     	    unixodbc-dev \
     	    libpq-dev \
     	    libsqlite3-dev \
     	    libaspell-dev \
     	    libsnmp-dev \
     	    libpcre3-dev \
    	    libtidy-dev \
    	    openssh-client \
    	    git \
    	    zip \
    	    unzip" \
    && docker-php-source extract \
    && apt-get update && apt-get install -y \
        $BUILD_DEPENDENCIES \
        $DEV_DEPENDENCIES \
    && docker-php-ext-install mbstring mcrypt pdo_mysql pdo_pgsql curl json intl gd xml zip bz2 opcache bcmath soap tidy \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && php -v \
    && docker-php-source delete \
    && exit $RESULT

# Phpunit support
RUN php -r "copy('https://phar.phpunit.de/phpunit.phar','/tmp/phpunit.phar');"
RUN chmod +x /tmp/phpunit.phar
RUN mv /tmp/phpunit.phar /usr/local/bin/phpunit

#Cron Tab for laravel Schedule
RUN apt install cron -y

#Need : /etc/init.d/apache2 start
WORKDIR /home
