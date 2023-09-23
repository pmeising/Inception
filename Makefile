name = inception


all:
	@printf "Launch configuration ${name}...\n"
	./srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d 


build:
	@printf "Building configuration ${name}...\n"
	./srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d --build


down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml down


re:
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d --build


clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@docker volume rm vol_wp vol_db


fclean:
	@printf "Complete cleanup of all docker configurations\n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/

.PHONY	: all build down re clean fclean

