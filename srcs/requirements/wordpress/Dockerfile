# ./tools/wordpress_install.sh	/
# ./conf/www.conf

FROM debian:buster

# Installing dependancies listed by the wordpress package on Debian
RUN apt update && apt install -y \
		curl \
		php \
		php-gd \
		php-mysql \
		php-mysqlnd \
		php-getid3 \
		php-fpm \
		mariadb-client \
&& apt clean

# Create the www-data user
RUN id www-data || useradd www-data 

# Copy php pool/user specific config file
COPY ./conf/www.conf	/etc/php/7.3/fpm/pool.d/

# Install cli tool
RUN curl --output /usr/local/bin/wp  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

# The cli complains about not having the permission to create the directory although we are root...
RUN	mkdir -p /var/www/wordpress
# Download wordpress directory
RUN /usr/local/bin/wp --path=/var/www/wordpress --allow-root core download --force

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh	/
RUN chmod +x /wordpress_install.sh

# Because that's where the pid file of php-fpm lives by default
# and it does not exist. Global setting, could be changed in /etc/php/7.3/fpm/php-fpm.conf
# `service start php-fpm` would also create it
RUN mkdir /run/php

EXPOSE 9000

# Redirect logs to stdout and stderr
# Because access.log and error_log are global settings and I can't be bothered to change them
# stderr because stdout redirection does not work though
RUN ln -sf /dev/stderr /var/log/php7.3-fpm.log 

# Install wp and run php
ENTRYPOINT ["/wordpress_install.sh"]
CMD ["php-fpm7.3", "--nodaemonize", "--allow-to-run-as-root"]
