FROM debian:buster

Run apt update && apt install \
	redis \
	php-redis \
&& apt clean

# https://redis.io/docs/manual/config/#configuring-redis-as-a-cache
# https://redis.io/docs/manual/eviction/

# Default redis port
EXPOSE 6379

ENTRYPOINT ["redis-server"]
CMD [ \
	"--maxmemory", "64mb", \
	"--maxmemory-policy", "allkeys-lru", \
	"--protected-mode", "no", \
	]
