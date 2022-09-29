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

RUN useradd www
RUN touch /var/log/php7.3-fpm.log \
		&& chown www:www /var/log/php7.3-fpm.log \
		&& chmod 777 /var/log/php7.3-fpm.log

#Pas nécessaire normalement
RUN mysql_install_db

COPY ./tools/init_database.sh	/
RUN chmod +x ./init_database.sh

ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

#RUN	red='\e[31m'																													; \
#    green='\e[32m'																													; \
#    cyan='\e[36m'																													; \
#    nocolor='\e[0m'																													; \
#    service mysql start																									|| return  ; \
#    sleep 5																															; \
#    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"													|| return  ; \
#    mysql -uroot -e "CREATE USER IF NOT EXISTS $MYSQL_USER;"															|| return  ; \
#    mysql -uroot -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO \"$MYSQL_USER\"@\"%\" IDENTIFIED BY $MYSQL_PASSWORD;" || return  ; \
#    mysql -uroot -e "DELETE FROM mysql.user WHERE User='';"																|| return  ; \
#    mysql -uroot -e "DROP DATABASE IF EXISTS test;"																		|| return  ; \
#    mysql -uroot -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"												|| return  ; \
#    mysql -uroot -e "FLUSH PRIVILEGES;"																					|| return  ; \
#    echo -e $cyan "Database created and secured" $nocolor																|| return  ; \
#    echo -e $cyan "Here are the current databases :" $nocolor																		; \
#    mysqlshow || return  ; 																											; \
#    echo -e $cyan "Here are the current users@host :" $nocolor  																	; \
#    mysql -e "SELECT user, host FROM mysql.user"																					; \
#    service mysql stop

# Expose the mariadb port
EXPOSE 3306

# Launch the script
ENTRYPOINT ["./init_database.sh"]
CMD [ "mysqld", "--bind-address=0.0.0.0", "--port=3306"]
