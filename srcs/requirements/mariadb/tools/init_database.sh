#!/bin/bash

red='\e[31m'
green='\e[32m'
cyan='\e[36m'
nocolor='\e[0m'

set -o vi

# Create the wordpress database
# Using heredoc because sql don't handle variable substitution
create_database()
{
	echo -e $cyan "Creating wordpress database and securing install..." $nocolor
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
}

main()
{
	service mysql start
	sleep 1
	create_database && echo -e $cyan "Database created and secured" $nocolor || return
	echo -e $cyan "Here are the current databases :" $nocolor
	mysqlshow
	echo -e $cyan "Here are the current users@host :" $nocolor
	mysql -e "SELECT user, host FROM mysql.user"
	service mysql stop
}

main && exec "$@" || echo $red "Failed to create database or to exec entrypoint command" $nocolor
