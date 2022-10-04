# ./tools/init_database.sh	
FROM debian:buster

RUN apt update && apt install -y \
	mariadb-server \
&& apt clean

COPY ./tools/init_database.sh	/
RUN chmod +x ./init_database.sh

# Expose the mariadb port
EXPOSE 3306

# Launch the script
ENTRYPOINT ["./init_database.sh"]
CMD [ "mysqld", "--bind-address=0.0.0.0"]
