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

## MARIADB
#MYSQL_DB_HOST=mariadb:3306
#MYSQL_USER=mariadb_db
#MYSQL_PASSWORD=5nC4H9N97nWQKQkJtuAqvMRizZKnOyG
#MYSQL_DATABASE=wordpress
#MYSQL_DATABASE_PREFIX=wp_

set -o vi

# Create the wordpress database
create_database()
{
	mysql <<-EOF
			CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
			CREATE USER IF NOT EXISTS $MYSQL_USER;
			GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"%" IDENTIFIED BY "$MYSQL_PASSWORD";
			DELETE FROM mysql.user WHERE User='';
			DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
			DROP DATABASE IF EXISTS test;
			DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
			FLUSH PRIVILEGES;
			EOF
	return $?
}

main()
{
	service mysql start
	sleep 1
	ret=create_database
	if (( $ret == 0 ));
	then
		echo "Database created and secured"
	else
		echo "Failed to create database : $?"
		exit 3036
	fi
	echo "Here are the current databases :"
	mysqlshow
	echo "Here are the current users@host :"
	mysql -e "SELECT user, host FROM mysql.user"
	service mysql stop
}

main ; exec "$@"
