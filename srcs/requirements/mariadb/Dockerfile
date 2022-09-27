FROM debian:buster

RUN apt update && apt install -y \
	mariadb-server \
	procps \
	vim \
&& apt clean

# Copy initialization script
#COPY ./conf/mariadb-server.cnf	/etc/mysql/my.cnf.d/
#COPY ./conf/my.cnf				/etc/mysql
COPY ./tools/init_database.sh	/
RUN chmod +x ./init_database.sh

# Expose the mariadb port
EXPOSE 3306

# Launch the script
ENTRYPOINT ["./init_database.sh"]
CMD [ "mariadbd", "--bind-address=0.0.0.0", "--port=3306","--user=$MYSQL_USER"]
