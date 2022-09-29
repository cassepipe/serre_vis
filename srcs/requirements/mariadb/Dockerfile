# ./tools/init_database.sh	
FROM debian:buster

RUN apt update && apt install -y \
	mariadb-server \
	procps \
	vim \
&& apt clean

# Je vois pas pourquoi c'est nécessaire mais bon
RUN mkdir -p /var/run/mysqld \
	&& chown --recursive mysql:mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld 

#Pas nécessaire normalement
RUN mysql_install_db

COPY ./tools/init_database.sh	/
RUN chmod +x ./init_database.sh

# Expose the mariadb port
EXPOSE 3306

# Launch the script
ENTRYPOINT ["./init_database.sh"]
CMD [ "mysqld", "--bind-address=0.0.0.0", "--port=3306"]
