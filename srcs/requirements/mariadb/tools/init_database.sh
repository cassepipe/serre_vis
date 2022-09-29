#!/bin/sh

set -o vi

# Create the wordpress database
create_database()
{
	mysql <<-EOF
			CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
			CREATE USER IF NOT EXISTS $MYSQL_USER;
			GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"%" IDENTIFIED BY "$MYSQL_PASSWORD";
			DELETE FROM mysql.user WHERE User='';
			--DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
			DROP DATABASE IF EXISTS test;
			DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
			FLUSH PRIVILEGES;
			EOF
	echo "mysql command return $?"
	return $?
}

main()
{
	service mysql start
	sleep 1
	service mysql status
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
