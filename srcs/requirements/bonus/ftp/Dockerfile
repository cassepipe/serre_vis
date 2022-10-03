FROM debian:buster

RUN apt update && apt install -y \
		vsftpd \
		openssl \
	&& apt clean

# Generate self-signed key/certificate pair
# -x509 generates certificates instead of certificate request
# -nodes --> No DES, deprecated on newer versions for -noenc (No encrytion)
# -new prompts for key info unless provided by -newkey
RUN openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes \
	-out /etc/ssl/ftp.pem \
	-keyout /etc/ssl/ftp.key \
	-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42Inc/OU=42School/CN=tpouget"

RUN echo " \
		listen=NO \
		listen_ipv6=YES \
		anonymous_enable=NO \
		local_enable=YES \
		write_enable=YES \
		local_umask=022 \
		dirmessage_enable=YES \
		use_localtime=YES \
		xferlog_enable=YES \
		connect_from_port_20=YES \
		chroot_local_user=YES \
		secure_chroot_dir=/var/run/vsftpd/empty \
		pam_service_name=vsftpd \
		rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem \
		rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key \
		ssl_enable=NO \
		pasv_enable=Yes \
		pasv_min_port=10000 \
		pasv_max_port=10100 \
		allow_writeable_chroot=YES \
" > /etc/vsftpd.conf

# Add the custom nginx configuration file
RUN	rm /etc/nginx/nginx.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]

ENTRYPOINT ["vsftpd"]
