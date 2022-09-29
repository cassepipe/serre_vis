# ./conf/nginx.conf 
FROM debian:buster

RUN apt update && apt install -y \
	procps \
	nginx \
	openssl \
&& apt clean

RUN id www-data || useradd www-data

# Create a directory for html files
RUN mkdir -p /var/www/wordpress/\
				/ssl\
				/log\
	&& chown -R www-data:www-data /var/lib/nginx /var/www/wordpress/

# Generate self-signed key/certificate pair
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /ssl/tpouget.42.fr.pem \
	-keyout /ssl/tpouget.42.fr.key \
	-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42Inc/OU=42School/CN=tpouget"

# Add the custom nginx configuration file
#COPY ./conf/tpouget.42.fr.conf /etc/nginx/http.d/
RUN	rm /etc/nginx/nginx.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Make log files symbolic links to stdout and stderr
#RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# Set the entrypoint on the port 443
EXPOSE 443

# Launch the webserver
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
