############################### Variables ################################

PROJECT_NAME 				= inception

DOCKER_COMPOSE_FILE			= srcs/docker-compose.yml

HOME_PATH					= /home/tpouget

DOCKER_COMPOSE_COMMAND		= sudo docker compose \
							  -f ${DOCKER_COMPOSE_FILE} \
							  -p ${PROJECT_NAME}

# **************************************************************************** #
#                                                                              #
#   Makefile rules :                                                           #
#                                                                              #
# - up :		Create and start containers                                    #
#                                                                              #
# - stop :		Stop services                                                  #
# - start :		Start services                                                 #
# - restart :	Restart services                                               #
#                                                                              #
# - clean :		Stop and remove containers, networks, and images               #
# - fclean :	Stop and remove containers, networks, images, and volumes      #
# - re :		fclean up                                                      #
#                                                                              #
# - pause :		Pause services                                                 #
# - unpause :	Unpause services                                               #
#                                                                              #
# - list :		List containers, networks, images, and volumes                 #
# - ps :		List containers                                                #
# - image :		List images                                                    #
#                                                                              #
# - debug_nginx / debug_wordpress / debug_mariadb :	Launch a shell in containers   #
# - log_nginx / log_wordpress / log_mariadb :	View output from containers    #
# - top_nginx / top_wordpress / top_mariadb :	Display the running processes  #
#                                                                              #
# **************************************************************************** #


up: | ${HOME_PATH}/data/mariadb ${HOME_PATH}/data/wordpress
	${DOCKER_COMPOSE_COMMAND} up --detach --pull never --build
	$(MAKE) ps

${HOME_PATH}/data/mariadb:
	sudo mkdir -p ${HOME_PATH}/data/mariadb

${HOME_PATH}/data/wordpress:
	sudo mkdir -p ${HOME_PATH}/data/wordpress

log_build:
	${DOCKER_COMPOSE_COMMAND} up --build > build_log.txt

rm_database:
	sudo rm -rf ${HOME_PATH}/data/mariadb/*	 ${HOME_PATH}/data/wordpress/*

rm_wordpress:
	sudo rm -rf ${HOME_PATH}/data/wordpress/*

clean: stop
	sudo docker system prune -a --force

fclean: stop rm_database rm_wordpress
	sudo docker system prune -a --force --volumes
	sudo docker volume rm -f inception_mariadb_volume inception_wordpress_volume

re: fclean up

exec_nginx:
	${DOCKER_COMPOSE_COMMAND} exec nginx /bin/bash

exec_mariadb:
	${DOCKER_COMPOSE_COMMAND} exec mariadb /bin/bash

exec_wordpress:
	${DOCKER_COMPOSE_COMMAND} exec wordpress /bin/bash

debug_nginx:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint ""  nginx /bin/bash

debug_mariadb:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" mariadb /bin/bash

debug_wordpress:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -it --entrypoint "" wordpress /bin/bash

run_nginx:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d nginx

run_mariadb:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d mariadb

run_wordpress:
	${DOCKER_COMPOSE_COMMAND} build
	${DOCKER_COMPOSE_COMMAND} run --rm -d wordpress

stop_all:
	docker stop `docker ps -q`

remove_exited:
	docker rm `docker ps -a -q`

log_nginx:
	${DOCKER_COMPOSE_COMMAND} logs --follow nginx
	
log_mariadb:
	${DOCKER_COMPOSE_COMMAND} logs --follow mariadb

log_wordpress:
	${DOCKER_COMPOSE_COMMAND} logs --follow wordpress

top_nginx:
	${DOCKER_COMPOSE_COMMAND} top nginx

top_mariadb:
	${DOCKER_COMPOSE_COMMAND} top mariadb 

top_wordpress:
	${DOCKER_COMPOSE_COMMAND} top wordpress

ps:
	${DOCKER_COMPOSE_COMMAND} ps
	docker ps

list:
	@printf "CONTAINERS LIST :\n"
	@sudo docker container ls
	@printf "\nIMAGES LIST :\n"
	@sudo docker image ls
	@printf "\nVOLUMES LIST :\n"
	@sudo docker volume ls
	@printf "\nNETWORKS LIST :\n"
	@sudo docker network ls

image:
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

open_dockerfiles:
	vim srcs/requirements/mariadb/Dockerfile srcs/requirements/wordpress/Dockerfile srcs/requirements/nginx/Dockerfile
