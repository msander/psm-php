FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        git\
        libonig-dev \
    && docker-php-ext-install iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring mysqli zip exif
    
# Install GMP    
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file \
&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
&& docker-php-ext-configure gmp  \
&& docker-php-ext-install gmp
    
# Install Redis
RUN pecl install -o -f redis \
&&  docker-php-ext-enable redis

# Config Locales
RUN apt-get install -y locales \
 && dpkg-reconfigure locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen \
 && locale-gen
  
# Cleanup
RUN rm -rf /tmp/pear

COPY uploads.ini /usr/local/etc/php/conf.d/
COPY disfuncs.ini /usr/local/etc/php/conf.d/
COPY sessions.ini /usr/local/etc/php/conf.d/
