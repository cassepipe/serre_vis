#!/bin/bash

red='\e[31m'
green='\e[32m'
blue='\e[36m'
nocolor='\e[0m'

WP_PATH=/usr/local/bin/wp
WORDPRESS_DATADIR=/var/www/wordpress
WP="$WP_PATH --path=$WORDPRESS_DATADIR --allow-root"

install_wp_cli()
{
	echo -e $blue"Installing the Wordpress CLI..."$nocolor
	curl --output $WP_PATH https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		|| return
	chmod +x $WP_PATH 
}

download_wordpress()
{
	echo -e $blue"Downloading WordPress..."$nocolor
	$WP core download --force
}

wait_for_database()
{
	echo -e $blue"Testing access to wordpress database..."$nocolor
	while ! mysql $MYSQL_DATABASE -e "quit"  --user=$MYSQL_USER  --password=$MYSQL_PASSWORD  --protocol=TCP  --host=mariadb ;
		do
			echo -e $blue "Waiting wordpress database..." $nocolor
			sleep 2
		done
}

config_wordpress_database_access()
{
	echo -e $blue"Configuring wordpress database access..."$nocolor
	$WP config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb \
		;
}

config_redis_cache()
{
		echo -e $blue"Configuring Wordpress to work with redis..."$nocolor
		$WP config set WP_REDIS_HOST redis
		$WP config set WP_CACHE true --raw
		$WP config set WP_CACHE_KEY_SALT $SITE_URL
		$WP plugin install redis-cache --activate
		$WP redis enable
}

# Sets up our url and admin user
install_website()
{
	echo -e $blue"Installing our website..."$nocolor
	$WP core install \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--skip-email \
		;

	#Change permalinks structure
	#$WP rewrite structure /%postname%/

	# Install the default theme
	#$WP theme install twentytwentytwo --force
}

# Create the non-admin wordpress user
create_user()
{
	echo -e $blue"Creating Wordpress user : ${WP_USER}"$nocolor
	$WP user create ${WP_USER} ${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASSWORD} \
		;
}

main()
{
	if [[ -f $WP_PATH ]] 
	then
		echo -e $green"The Worpress CLI is already installed"$nocolor
	else
		install_wp_cli || return
	fi
	#if [[ -d $WORDPRESS_DATADIR ]] 
	#then
	#    echo -e $green "The WordPress directory is already downloaded" $nocolor
	#else
		download_wordpress
	#fi
	if [[ -f "${WORDPRESS_DATADIR}/wp-config.php" ]]
	then
		echo -e $green"WordPress is already configured"$nocolor
	else
		echo -e $blue"Wordpress installation ..."$nocolor
		wait_for_database \
		&& config_wordpress_database_access \
		&& install_website \
		&& create_user \
		&& echo -e $green"The WordPress installation is complete"$nocolor \
		|| return
	fi
	if [[ $BONUS == "yes" ]]; then
		config_redis_cache
		echo -e $green"Redis cache for wordpress is configured"$nocolor
		curl -L --output $WORDPRESS_DATADIR/adminer.php "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"
		chmod +x $WORDPRESS_DATADIR/adminer.php
		echo -e $green"Downloaded Adminer"
	fi
	chown -R www-data:www-data ${WORDPRESS_DATADIR}
}

if main ; then exec "$@"; else echo -e $red"Wordpress setup failed : $?"$nocolor ; fi
