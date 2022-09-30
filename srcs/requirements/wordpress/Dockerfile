# ./tools/wordpress_install.sh	/
# ./conf/www.conf
# ./conf/php.ini

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

RUN mkdir -p /var/www/wordpress \
	&& chown www-data:www-data /var/www/wordpress

#RUN touch /var/log/php7.3-fpm.log \
#        && chown www-data:www-data /var/log/php7.3-fpm.log \
#        && chmod +x /var/log/php7.3-fpm.log

# Copy php config files
COPY ./conf/www.conf	/etc/php/7.3/fpm/pool.d/
COPY ./conf/php.ini		/etc/php/7.3/fpm

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh	/
RUN chmod +x /wordpress_install.sh

RUN mkdir /run/php

# Expose the port 9000
EXPOSE 9000

RUN ln -sf /dev/stdout /var/log/php7.3-fpm.log  && ln -sf /dev/stderr /var/log/php7.3-fpm.log 
# Install wp and run php
ENTRYPOINT ["/wordpress_install.sh"]
CMD ["php-fpm7.3", "--nodaemonize", "--allow-to-run-as-root"]
#CMD ["php-fpm7.3", "--nodaemonize"]
#CMD ["su", "www-data", "-c", "php-fpm7.3 --nodaemonize"]
