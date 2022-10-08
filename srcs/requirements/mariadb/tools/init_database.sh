#!/bin/bash

red='\e[31m'
green='\e[32m'
cyan='\e[36m'
nocolor='\e[0m'

create_wordpress_database_user()
{
	echo -e $cyan"Creating wordpress user..." $nocolor
	mysql -u root --password=$MYSQL_ROOT_PASSWORD <<-EOF
			CREATE USER IF NOT EXISTS $MYSQL_USER;
			GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"%" IDENTIFIED BY "$MYSQL_PASSWORD";
			FLUSH PRIVILEGES;
			EOF
}

secure_database()
{
	echo -e $cyan"Securing database..." $nocolor
	mysql -u root --password=$MYSQL_ROOT_PASSWORD <<-EOF
			DELETE FROM mysql.user WHERE User='';
			DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
			DROP DATABASE IF EXISTS test;
			DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
			--ALTER USER root@localhost IDENTIFIED WITH mysql_native_password;
			--ALTER USER root@localhost IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
			FLUSH PRIVILEGES;
			EOF
}

main()
{
	service mysql start
	sleep 1
	if mysql -e "CREATE DATABASE $MYSQL_DATABASE"; then
		create_wordpress_database_user && echo -e $cyan"Database and database user created" $nocolor || return
		secure_database && echo -e $cyan "Database secured" $nocolor || return
	else
		echo -e $green"Database already exists" $nocolor
	fi
	echo -e $cyan"Here are the current databases :" $nocolor
	mysqlshow -u root --password=$MYSQL_ROOT_PASSWORD
	echo -e $cyan"Here are the current users@host :" $nocolor
	mysql -u root --password=$MYSQL_ROOT_PASSWORD -e "SELECT user, host, password FROM mysql.user"
	service mysql stop
}

main; exec "$@" || echo -e $red "Failed to create database or to exec entrypoint command" $nocolor
