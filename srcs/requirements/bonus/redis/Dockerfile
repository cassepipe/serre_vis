FROM debian:buster

Run apt update && apt install -y \
	redis \
	php-redis \
&& apt clean

# https://redis.io/docs/manual/config/#configuring-redis-as-a-cache
# https://redis.io/docs/manual/eviction/

# Default redis port
EXPOSE 6379

ENTRYPOINT ["redis-server"]
CMD [ "--loglevel", "verbose", "--maxmemory", "64mb",  "--maxmemory-policy", "allkeys-lru", "--protected-mode", "no"  ]
