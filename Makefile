################################# Variables ###################################
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

SHELL						= bash

PROJECT_NAME 				= inception

DOCKER_COMPOSE_FILE			= srcs/docker-compose.yml

USER						= tpouget

HOME						= /home/${USER}

BONUS						= yes

#SUDO						= sudo -E

DOCKER_COMPOSE_COMMAND		= ${SUDO} docker compose \
							  -f ${DOCKER_COMPOSE_FILE} \
							  -p ${PROJECT_NAME}

################################### Rules #####################################

# Start the services
up:	| ${HOME}/data/mariadb ${HOME}/data/wordpress
	${DOCKER_COMPOSE_COMMAND} up --pull never --build --detach
	$(MAKE) ps

bonus:	| ${HOME}/data/mariadb ${HOME}/data/wordpress
	BONUS=yes ${DOCKER_COMPOSE_COMMAND} --profile bonus up --build --detach
	$(MAKE) ps

${HOME}/data/mariadb:
	mkdir -p ${HOME}/data/mariadb

${HOME}/data/wordpress:
	mkdir -p ${HOME}/data/wordpress

setup:
	@echo "Adding ${USER} to the docker group:"
	sudo usermod -a -G docker ${USER}
	@echo "${USER} now belongs to:"
	groups
	@echo "Adding ${USER} to /etc/hosts:"
	sudo echo "127.0.0.1	${USER}.42.fr" >> /etc/hosts

# ** Basic docker compose commands **

ps:
	${DOCKER_COMPOSE_COMMAND} ps
	docker ps

# Removes stopped service containers (Can be running...)
rm:
	${DOCKER_COMPOSE_COMMAND} rm

down:
	${DOCKER_COMPOSE_COMMAND} down

images:
	${DOCKER_COMPOSE_COMMAND} images

pause:
	${DOCKER_COMPOSE_COMMAND} pause

unpause:
	${DOCKER_COMPOSE_COMMAND} unpause

start:
	${DOCKER_COMPOSE_COMMAND} start

stop:
	${DOCKER_COMPOSE_COMMAND} stop

restart:
	${DOCKER_COMPOSE_COMMAND} restart

logs:
	${DOCKER_COMPOSE_COMMAND} logs -f

# Cleanup 

rm_database:
	sudo rm -rf ${HOME}/data/mariadb/*

rm_wordpress:
	sudo rm -rf ${HOME}/data/wordpress/*

clean: stop remove_exited_containers
	docker system prune -a --force

stop_all:
	-docker stop `docker ps -q`

remove_exited_containers:
	-docker rm `docker ps -a -q -f status=exited`

remove_all_containers:	stop_all
	-docker rm `docker ps -a -q`

# Removes persistent data
fclean: stop rm_database rm_wordpress
		sudo docker system prune -a --force --volumes
		-sudo docker volume rm -f `sudo docker volume ls -q`

re:		fclean
		$(MAKE)

# ** DEBUGGING **

# Run bash in a already running container

exec_nginx:
	${DOCKER_COMPOSE_COMMAND} exec nginx /bin/bash

exec_mariadb:
	${DOCKER_COMPOSE_COMMAND} exec mariadb /bin/bash

exec_wordpress:
	${DOCKER_COMPOSE_COMMAND} exec wordpress /bin/bash

exec_redis:
	${DOCKER_COMPOSE_COMMAND} exec redis /bin/bash

# Run bash instead of entrypoint

debug_nginx:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint ""  nginx /bin/bash

debug_mariadb:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" mariadb /bin/bash

debug_wordpress:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" wordpress /bin/bash

debug_bonus_wordpress:
	${DOCKER_COMPOSE_COMMAND} build
	BONUS=yes ${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" wordpress /bin/bash

debug_redis:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" redis /bin/bash

# Run services individually

run_nginx:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d nginx

run_mariadb:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d mariadb

run_wordpress:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d wordpress

log_nginx:
	${DOCKER_COMPOSE_COMMAND} logs --follow nginx
	
log_mariadb:
	${DOCKER_COMPOSE_COMMAND} logs --follow mariadb

log_wordpress:
	${DOCKER_COMPOSE_COMMAND} logs --follow wordpress

log_redis:
	${DOCKER_COMPOSE_COMMAND} logs --follow redis

top_nginx:
	${DOCKER_COMPOSE_COMMAND} top nginx

top_mariadb:
	${DOCKER_COMPOSE_COMMAND} top mariadb 

top_wordpress:
	${DOCKER_COMPOSE_COMMAND} top wordpress

list_containers:
	docker container ls

list_volumes:
	docker volume ls

list_network:
	docker network ls

open_dockerfiles:
	vim srcs/requirements/mariadb/Dockerfile srcs/requirements/wordpress/Dockerfile srcs/requirements/nginx/Dockerfile srcs/requirements/bonus/redis/Dockerfile srcs/requirements/bonus/ftp/Dockerfile

open_wp_script:
	vim  srcs/requirements/wordpress/tools/wordpress_install.sh 

open_mariadb:
	vim srcs/requirements/mariadb/

