# ./tools/wordpress_install.sh	/
# ./conf/www.conf

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
		mariadb-client \
		vim \
&& apt clean

# Create the www-data user
RUN id www-data || useradd www-data 

#RUN mkdir -p /var/www/wordpress \
#    && chown www-data:www-data /var/www/wordpress

# Copy php pool/user specific config file
COPY ./conf/www.conf	/etc/php/7.3/fpm/pool.d/

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh	/
RUN chmod +x /wordpress_install.sh

# Because that's where the pid file of php-fpm lives by default
# and it does not exist. Global setting, could be changed in /etc/php/7.3/fpm/php-fpm.conf
RUN mkdir /run/php

# Expose the port 9000
EXPOSE 9000

# Redirect logs to stdout and stderr
# Because access.log and error_log are global settings and I can't be bothered to change them
# stderr because stdout redirection does not work though
RUN ln -sf /dev/stderr /var/log/php7.3-fpm.log 

# Install wp and run php
ENTRYPOINT ["/wordpress_install.sh"]
CMD ["php-fpm7.3", "--nodaemonize", "--allow-to-run-as-root"]
#CMD ["su", "www-data", "-c", "php-fpm7.3 --nodaemonize"]
