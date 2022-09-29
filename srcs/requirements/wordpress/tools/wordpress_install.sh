#! /bin/sh

WORDPRESS_DATADIR=/var/www/wordpress

remove_wordpress ()
{
	rm -rf ${WORDPRESS_DATADIR}
}

install_wp_cli()
{
	echo "Installing the Wordpress CLI..."
	curl --output /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		|| return
	chmod +x /usr/local/bin/wp 
}

download_wordpress()
{
	echo "Downloading WordPress..."
	su ${MYSQL_USER} -c " wp core download --path=$WORDPRESS_DATADIR --force #--skip-content"
}

test_database_access()
{
	echo "Testing access to wordpress database"
	mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --protocol=TCP --host=${MYSQL_DATABASE_HOST} $MYSQL_DATABASE -e "quit"
}

# Configuration of wp-config.php
config_wordpress()
{
	echo "Configuring Wordpress..."
	su ${MYSQL_USER} -c "wp config create \
		--path=${WORDPRESS_DATADIR} \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=${MYSQL_DATABASE_HOST} 
		"
}

# Wordpress installation
install_wordpress()
{
	echo "Installing Wordpress..."
	su ${MYSQL_USER} - c "wp core install \
		--path= ${WORDPRESS_DATADIR} \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--skip-email
	"

	#Change permalinks structure
	#wp rewrite structure /%postname%/

	# Install the default theme
	#wp theme install twentytwentytwo --force
}

# Create the second wordpress user
create_user()
{
	echo "Creating Worpress user ${WP_USER}"
	wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD}
}

main()
{
	if [ -f "${WORDPRESS_DATADIR}/wp-config.php" ];
	then
		echo "WordPress is already downloaded."
	else
		echo "Wordpress installation ..."
		test_database_access \
		&& install_wp_cli \
		&& download_wordpress \
		&& config_wordpress \
		&& install_wordpress \
		&& create_user \
		&& chown -R www:www ${WORDPRESS_DATADIR} \
		&& wp cron event run --due-now \
		&& echo "The WordPress installation is completed."
	fi
}

set -o vi
#ret=main; if (( $ret == 0 )); then exec "$@"; else echo "Worpress setup failed : $ret"; fi ; return ret;
