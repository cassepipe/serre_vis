FROM debian:buster

RUN apt update && apt install -y \
		curl \
		procps \
		php \
		php-gd \
		php-mysql \
		php-mysqlnd \
		php-getid3 \
		php-fpm \
&& apt clean

# Create the www user
RUN useradd www && \
		mkdir -p /var/www/wordpress && \
		chown www:www /var/www/wordpress

# Copy php config files
COPY ./conf/www.conf	/etc/php7.3/php-fpm.d/
COPY ./conf/php.ini		/etc/php7.3/

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh	/
RUN chmod +x /wordpress_install.sh

RUN mkdir /run/php

# Expose the port 9000
EXPOSE 9000

# Install wp and run php
CMD ["/wordpress_install.sh"]
