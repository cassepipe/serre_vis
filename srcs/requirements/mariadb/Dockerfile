FROM debian:buster

RUN apt update && apt add installe - y \
	mariadb-server \
	procps \
	top \
&& apt clean

# Copy initialization script
COPY ./conf/mariadb-server.cnf	/etc/my.cnf.d/
COPY ./conf/my.cnf				/etc/
COPY ./tools/init_database.sh	/

# Expose the mariadb port
EXPOSE 3306

# Launch the script
CMD ["sh", "/init_database.sh"]
