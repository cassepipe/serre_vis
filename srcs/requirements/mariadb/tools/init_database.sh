#! /bin/sh

DATADIR=/var/lib/mysql

# This function set the default options to mariadb database
secure_database()
{
	cat << EOF | mysql_secure_installation

Y
n
Y
Y
Y
Y
EOF
}


# Create the wordpress database
create_database()
{
	cat << EOF | mariadb -u root
CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"localhost" IDENTIFIED BY "$MYSQL_PASSWORD";
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@"%" IDENTIFIED BY "$MYSQL_PASSWORD";
FLUSH PRIVILEGES;
EOF
}


main()
{
	if [ ! -z "$(ls -A $DATADIR)" ];
	then
		echo "The database doesn't need to be created."
		systemctl start mariadb 
		systemctl stop mariadb 
	else
		echo "Database installation ..."
		/etc/init.d/mariadb setup
		systemctl start mariadb
		secure_database
		create_database
		systemctl restart mariadb
		systemctl stop mariadb 
		echo "The database installation is completed."
	fi
}

main
exec /usr/bin/mysqld --user=mysql --console
