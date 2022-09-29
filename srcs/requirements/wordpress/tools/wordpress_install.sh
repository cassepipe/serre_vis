#! /bin/sh

red='\e[31m'
green='\e[32m'
blue='\e[36m'
nocolor='\e[0m'

WORDPRESS_DATADIR=/var/www/wordpress

remove_wordpress ()
{
	rm -rf ${WORDPRESS_DATADIR}
}

install_wp_cli()
{
	echo -e $blue "Installing the Wordpress CLI..." $nocolor
	curl --output /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		|| return
	chmod +x /usr/local/bin/wp 
}

download_wordpress()
{
	echo -e $blue "Downloading WordPress..." $nocolor
	wp core download --path=$WORDPRESS_DATADIR --force --allow-root #--skip-content"
}

test_database_access()
{
	echo -e $blue "Testing access to wordpress database" $nocolor
	mysql $MYSQL_DATABASE -e "quit" \
		--user=$MYSQL_USER \
		--password=$MYSQL_PASSWORD \
		--protocol=TCP \
		--host=${MYSQL_DATABASE_HOST}
}

config_wordpress()
{
	echo -e $blue "Configuring Wordpress..." $nocolor
	wp config create \
		--allow-root \
		--path=${WORDPRESS_DATADIR} \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=${MYSQL_DATABASE_HOST} 
}

# Sets up our url and admin user
install_wordpress()
{
	echo -e $blue "Installing Wordpress..." $nocolor
	wp core install \
		--allow-root \
		--path=${WORDPRESS_DATADIR} \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--skip-email

	#Change permalinks structure
	#wp rewrite structure /%postname%/

	# Install the default theme
	#wp theme install twentytwentytwo --force
}

# Create the non-admin wordpress user
create_user()
{
	echo -e $blue "Creating Wordpress user : ${WP_USER}" $nocolor
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
		--allow-root \
		--path=${WORDPRESS_DATADIR} \
		--user_pass=${WP_USER_PASSWORD}
}

main()
{
	if [ -f "${WORDPRESS_DATADIR}/wp-config.php" ];
	then
		echo -e $green "WordPress is already downloaded" $nocolor
	else
		echo -e $blue "Wordpress installation ..." $nocolor
		sleep 5
		test_database_access \
		&& install_wp_cli \
		&& download_wordpress \
		&& config_wordpress \
		&& install_wordpress \
		&& create_user \
		&& chown -R www-data:www-data ${WORDPRESS_DATADIR} \
		&& echo -e $green "The WordPress installation is complete" $nocolor
	fi
}

set -o vi
#ret=main; if (( $ret == 0 )); then exec "$@"; else echo -e $red "Wordpress setup failed : $ret" $nocolor; fi ; return ret;
if (( main )); then exec "$@"; fi
