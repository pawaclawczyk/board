FROM php:7

RUN apt-get update && apt-get install -y \
    sudo \
    git \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring zip

RUN mkdir --parent /usr/src/composer && \
    cd /usr/src/composer && \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/bin/composer

WORKDIR /app

CMD ["php", "--version"]
