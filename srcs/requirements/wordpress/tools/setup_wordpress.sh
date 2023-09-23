#!/bin/sh

if  ! /usr/local/bin/wp --allow-root core --path=/var/www/html is-installed; then
	/usr/local/bin/wp --path=/var/www/html core download --allow-root
	echo "************************* Got wordpress *****************************"
	mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g" /var/www/html/wp-config.php
	sed -i "s/username_here/$WORDPRESS_DB_USER/g" /var/www/html/wp-config.php
	sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" /var/www/html/wp-config.php
	sed -i "s/localhost/$WORDPRESS_DB_HOST/g" /var/www/html/wp-config.php
	while ! wp --allow-root --path=/var/www/html db check; do
		sleep 20
	done
	wp core install --path=/var/www/html --url=mtrietz.42.fr \
	--title='Wordpress for project inception' \
	--admin_user=$WP_ADMIN \
	--adminpassword=$WP_ADMIN_PASS \
	--admin_email=pmeising@students.42wolfsburg.de \
	--allow-root \
	--skip-email

	wp --path=/var/www/html user create ${WP_USER} ${WP_USER}@email.de \
	--role=author --user_pass=$WP_USER_PASS --allow-root

fi
chown -R nginx:www-data /var/www/html/*
find /var/www/html -type d -exec chmod 775 {} \;  
find /var/www/html -type f -exec chmod 664 {} \;
chmod g+s /var/www/html
exec "$@"


# # Variables
# FILE_PATH_CONFIG_SRC="./wordpress/wp-config-sample.php"
# FILE_PATH_CONFIG_DST="./wordpress/wp-config.php"

# # ANSI escape codes for text colors
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# RESET='\033[0m'  # Reset text color to default



# # -f -> does it exist?
# if [ -f ./wordpress/wp-config-sample.php ]; then
#     echo -e "${GREEN}WordPress already installed${RESET}"
#     echo -e "${GREEN}Skipping download...${RESET}"
# else
#     echo -e "${YELLOW}Downloading WordPress...${RESET}"
#     wget https://wordpress.org/latest.tar.gz
#     tar -xzvf /var/www/html/latest.tar.gz
#     rm -f latest.tar.gz
#     chown -R www-data:www-data wordpress
#     echo -e "${GREEN}Download successful${RESET}"
# fi

# # wp-config.php only exists if WordPress was configured.
# if [ -f $FILE_PATH_CONFIG_DST ]; then
#     echo -e "${GREEN}WordPress already initialized${RESET}"
#     echo -e "${GREEN}Skipping configuration...${RESET}"
# else
#     echo -e "${YELLOW}Creating wp-config.php...${RESET}"
#     # sed -> Stream editor -i (in place change -> effectively overwriting) s/ -> search
#     sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g"  $FILE_PATH_CONFIG_SRC
#     sed -i "s/username_here/$WORDPRESS_DB_USER/g"           $FILE_PATH_CONFIG_SRC
#     sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g"  $FILE_PATH_CONFIG_SRC
#     sed -i "s/localhost/$WORDPRESS_DB_HOST/g"          $FILE_PATH_CONFIG_SRC
#     mv $FILE_PATH_CONFIG_SRC $FILE_PATH_CONFIG_DST

# 	# Install WordPress and set up initial users
#     echo -e "${YELLOW}Setting up initial WordPress users...${RESET}"
#     wp core install \
#         --path=/var/www/html \
#         --url="https://pmeising.42.fr" \
#         --title="Inception project" \
#         --admin_user="$WP_ADMIN" \
#         --admin_password="$WP_ADMIN_PASS" \
#         --admin_email="admin@42.com"

# 	echo -e "${GREEN} Admin created . . .${RESET}"

#     wp --path=/var/www/html \
#        user create "$WP_USER" \
#        "$WP_USER@42.com" \
#        --role="editor"

#     echo -e "${GREEN}WordPress configuration and user setup complete${RESET}"
# fi

# echo -e "${GREEN}Starting /usr/sbin/php-fpm8 process in foreground${RESET}"

# exec "$@"

