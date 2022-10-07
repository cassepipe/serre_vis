#!/bin/bash

red='\e[31m'
green='\e[32m'
cyan='\e[36m'
nocolor='\e[0m'

WP_PATH=/usr/local/bin/wp
WORDPRESS_DATADIR=/var/www/wordpress
WP="$WP_PATH --path=$WORDPRESS_DATADIR --allow-root"

install_wp_cli()
{
	echo -e $cyan"Installing the Wordpress CLI..."$nocolor
	curl --output $WP_PATH https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		|| return
	chmod +x $WP_PATH 
}

download_wordpress()
{
	echo -e $cyan"Downloading WordPress..."$nocolor
	$WP core download --force
}

wait_for_database()
{
	echo -e $cyan"Testing access to wordpress database..."$nocolor
	while ! mysql $MYSQL_DATABASE -e "quit"  --user=$MYSQL_USER  --password=$MYSQL_PASSWORD  --protocol=TCP  --host=mariadb ;
		do
			echo -e $cyan "Waiting wordpress database..." $nocolor
			sleep 2
		done
}

config_wordpress_database_access()
{
	echo -e $cyan"Configuring wordpress database access..."$nocolor
	$WP config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb \
		;
}

config_redis_cache()
{
		echo -e $cyan"Configuring Wordpress to work with redis..."$nocolor
		$WP config set WP_REDIS_HOST redis
		$WP config set WP_CACHE true --raw
		$WP config set WP_CACHE_KEY_SALT $SITE_URL
		$WP plugin install redis-cache --activate
		$WP redis enable
}

# Sets up our url and admin user
install_website()
{
	echo -e $cyan"Installing our website..."$nocolor
	$WP core install \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--skip-email \
		;
}

# Create the non-admin wordpress user
create_user()
{
	echo -e $cyan"Creating Wordpress user : ${WP_USER}"$nocolor
	$WP user create ${WP_USER} ${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASSWORD} \
		;
}

main()
{
	#echo -e $cyan"Installing the Wordpress CLI..."$nocolor
	#install_wp_cli || return
	echo -e $cyan"Downloading the Wordpress directory..."$nocolor
	download_wordpress || return
	if [[ -f "${WORDPRESS_DATADIR}/wp-config.php" ]]
	then
		echo -e $green"WordPress is already configured"$nocolor
	else
		echo -e $cyan"Wordpress configuration ..."$nocolor
		wait_for_database \
		&& config_wordpress_database_access \
		&& install_website \
		&& create_user \
		&& echo -e $green"The WordPress configuration has completed"$nocolor \
		|| return
	fi
	if [[ $BONUS == "yes" ]]; then
		config_redis_cache
		echo -e $green"Redis cache for wordpress is configured"$nocolor
		curl -L --output $WORDPRESS_DATADIR/adminer.php "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"
		chmod +x $WORDPRESS_DATADIR/adminer.php
		echo -e $green"Adminer is installed"$nocolor
	fi
	chown -R www-data:www-data ${WORDPRESS_DATADIR}
}

if main ; then exec "$@"; else echo -e $red"Wordpress setup failed : $?"$nocolor ; fi
