FROM ubuntu:latest

# Install nginx, php7-fpm, supervisor
RUN apt-get update \
    && apt-get install -y nginx supervisor curl libpng12-dev libjpeg-dev libmcrypt-dev \
    php7.0 php7.0-fpm php-pear php7.0-dev php7.0-gd php7.0-curl php7.0-mysqli php7.0-mbstring php7.0-zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Install composer
RUN curl -o /usr/local/bin/composer https://getcomposer.org/composer.phar \
	&& chmod +x /usr/local/bin/composer
# Start PHP fpm
RUN service php7.0-fpm start

# Configuration
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
RUN chmod 400 /etc/supervisord.conf && chmod 400 /etc/nginx/conf.d/default.conf

# Stream nginx logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf
