FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        git\
    && docker-php-ext-install iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
    
# Install GMP    
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp 
RUN docker-php-ext-install gmp
    
# Install Redis
RUN pecl install -o -f redis \
&&  docker-php-ext-enable redis
    
RUN docker-php-ext-install mbstring mysqli zip exif
RUN apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8
  
RUN rm -rf /tmp/pear

RUN echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

COPY uploads.ini /usr/local/etc/php/conf.d/
COPY disfuncs.ini /usr/local/etc/php/conf.d/
COPY sessions.ini /usr/local/etc/php/conf.d/
