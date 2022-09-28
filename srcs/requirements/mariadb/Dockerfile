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

###############################################################################

#FROM debian:buster

#RUN apt-get -y update && apt-get -y install mariadb-server

#RUN mkdir -p /var/run/mysqld \
#    && chown -R mysql:mysql /var/run/mysqld \
#    && chmod 777 /var/run/mysqld 

#RUN mysql_install_db

#ARG MYSQL_DATABASE
#ARG MYSQL_ROOT_PASSWORD
#ARG MYSQL_USER
#ARG MYSQL_USER_PASSWORD

#RUN if ! [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; \
#    then \
#        mysqld & sleep 5 \
#        && cat "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password; \
#                ALTER USER root@localhost IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; \
#                CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
#                GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
#                DROP DATABASE test; \
#                DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'; \
#                FLUSH PRIVILEGES;" | mysql ; \
#    fi

#EXPOSE 3306
#ENTRYPOINT ["mysqld"] 
#CMD ["--bind-address=0.0.0.0"]
