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
#MYSQL_DB_PREFIX=wp_

set -o vi

start_server()
{
	service mysql start
}

stop_server()
{
	service mysql stop
}

# Create the wordpress database
create_database()
{
	mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS $MYSQL_USER;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"localhost" IDENTIFIED BY "$MYSQL_PASSWORD";
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"wordpress" IDENTIFIED BY "$MYSQL_PASSWORD";
FLUSH PRIVILEGES;
EOF
}

run_server()
{
	/usr/sbin/mysqld --bind-address=0.0.0.0 --port=3306 --user=$MYSQL_USER
}

main()
{
	service mysql start
	create_database
	#mysqladmin password $MYSQL_PASSWORD
	service mysql stop
}

launch()
{
	exec /usr/sbin/mysqld --bind-address=0.0.0.0 --port=3306 --user=$MYSQL_USER
}

main
exec "$@"
