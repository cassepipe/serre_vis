FROM debian:buster

# Update the index of available packages,
# Upgrade the currently installed packages
# And install redis
RUN apt update && apt install -y \
	redis\
	php-redis \
&& apt clean


# Edit the redis configuration file
RUN mv /etc/redis.conf /etc/redis.conf.backup
RUN echo maxmemory 256mb > /etc/redis.conf
RUN echo maxmemory-policy allkeys-lru >> /etc/redis.conf

# Expose the redis port
EXPOSE 6379

# Launch the redis server
ENTRYPOINT ["redis-server"]
CMD ["/etc/redis.conf", "--protected-mode", "no"]
