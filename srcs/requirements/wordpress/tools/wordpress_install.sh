#! /bin/sh

## WORDPRESS
#SITE_TITLE=Inception
#SITE_URL=https://tpouget.42.fr

## WORDPRESS ADMIN USER
#WP_ADMIN_USER=tpouget
#WP_ADMIN_PASSWORD=E72sX9nQIWhFAc6zjkvQmMJphYxVuqu
#WP_ADMIN_EMAIL=contact@tpouget.42.fr

## WORDPRESS SECOND USER
#WP_USER=utilisateur
#WP_USER_PASSORD=eWV2G0GmNQoD5YsP7I6PyFg6nMZCLVr
#WP_USER_EMAIL=user@charles-mariot.fr

## MARIADB
#MYSQL_DB_HOST=mariadb:3306
#MYSQL_USER=mariadb_db
#MYSQL_PASSWORD=5nC4H9N97nWQKQkJtuAqvMRizZKnOyG
#MYSQL_DATABASE=wordpress
#MYSQL_DB_PREFIX=wp_

WORDPRESS_CONFIG_FILE=/var/www/wordpress/wp-config.php

# WP-CLI = Command line interface for WordPress
install_wp_cli()
{
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
}

# Download wordpress
download_wordpress()
{
	echo "Downloading WordPress"
	wp core download --path=/var/www/wordpress --force --allow-root #--skip-content
}

# Configuration of wp-config.php
config_wordpress()
{
	echo "WordPress configuration"
	cd /var/www/wordpress

	wp config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=${MYSQL_DB_HOST} \
		--allow-root 
		#--dbprefix=${MYSQL_DB_PREFIX} \

	#sed -i "62i define('FS_METHOD', 'direct');" wp-config.php
}

# Wordpress installation
install_wordpress()
{
	echo "WordPress installation"
	cd /var/www/wordpress

	wp core install \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--allow-root \
		--skip-email

	#Change permalinks structure
	wp rewrite structure /%postname%/

	# Install the default theme
	wp theme install twentytwentytwo --force
}

# Create the second wordpress user
create_user()
{
	wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSORD}
}

main()
{
	install_wp_cli
	if [ -f "$WORDPRESS_CONFIG_FILE" ];
	then
		echo "WordPress is already downloaded."
	else
		echo "Wordpress installation ..."
		install_wp_cli
		download_wordpress
		config_wordpress
		install_wordpress
		create_user
		chown -R www:www /var/www/wordpress
		wp cron event run --due-now
		echo "The WordPress installation is completed."
	fi
}

main
exec "@"
