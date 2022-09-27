DATADIR=/var/lib/mysql

CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"localhost" IDENTIFIED BY "$MYSQL_PASSWORD";
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"%" IDENTIFIED BY "$MYSQL_PASSWORD";
FLUSH PRIVILEGES;


main()
{
	if [ ! -z "$(ls -A $DATADIR)" ];
	then
		echo "The database doesn't need to be created."
	else
		echo "Database installation ..."
		service mysql start
		secure_database
		create_database
		service mysql stop
		echo "The database installation is completed."
	fi
}

launch()
{
	exec /usr/sbin/mysqld --user=mysql --console
}

remove_install()
{
	rm -rf $DATADIR/*
	echo "Removed $DATADIR content"
}

#main
#exec "$@"
