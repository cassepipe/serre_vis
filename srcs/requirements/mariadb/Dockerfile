# ./tools/init_database.sh	
FROM debian:buster

RUN apt update && apt install -y \
	mariadb-server \
&& apt clean

RUN apt-get -y update && apt-get -y install mariadb-client mariadb-server \
	&& mkdir -p /var/run/mysqld \
	&& chown -R mysql:mysql /var/run/mysqld && chmod 777 /var/run/mysqld

COPY ./tools/init_database.sh	/
RUN chmod +x ./init_database.sh

# Expose the mariadb port
EXPOSE 3306

# Launch the script
ENTRYPOINT ["./init_database.sh"]
CMD [ "mysqld", "--bind-address=0.0.0.0"]
