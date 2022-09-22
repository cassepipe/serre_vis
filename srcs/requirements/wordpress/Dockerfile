FROM debian:buster

# Update the index of available packages,
# Upgrade the currently installed packages
# And install php8 and php8 packages
RUN apt update && apt install -y \
	curl\
	mariadb-client\
	php\
	php8-curl\
	php8-ctype\
	php8-dom\
	php8-exif\
	php8-fileinfo\
	php8-fpm\
	php8-gd\
	php8-iconv\
	php8-intl\
	php8-mbstring\
	php8-mysqli\
	php8-pecl-imagick\
	php8-phar\
	php8-redis\
	php8-session\
	php8-xml\
	php8-zip
&& apt clean

# Create the www user
RUN useradd www && \
		mkdir -p /var/www/wordpress && \
		chown www:www /var/www/wordpress

# Copy php config files
COPY ./conf/www.conf	/etc/php8/php-fpm.d/
COPY ./conf/php.ini		/etc/php8/

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh	/
RUN chmod +x /wordpress_install.sh

# Expose the port 9000
EXPOSE 9000

# Install wp and run php
CMD ["/wordpress_install.sh"]
