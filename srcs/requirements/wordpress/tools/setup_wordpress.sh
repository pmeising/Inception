#!/bin/sh

# variables
FILE_PATH_CONFIG_SRC="./wordpress/wp-config-sample.php"
FILE_PATH_CONFIG_DST="./wordpress/wp-config.php"

# -f -> does it exist?
if [ -f ./wordpress/wp-config-sample.php ]; then
	echo 'Wordpress already installed'
	echo 'Skipping download...'
else
	echo 'Downloading Wordpress...'
	wget https://wordpress.org/latest.tar.gz
	tar -xzvf /var/www/html/latest.tar.gz
	rm -f latest.tar.gz
	chown -R www-data:www-data wordpress
	echo 'Download successful'
fi

# wp-config.php only exists if wordpress was configured.
if [ -f $FILE_PATH_CONFIG_DST ]; then
	echo 'Wordpress already initialized'
	echo 'Skipping configuration...'
else
	echo 'Creating wp-config.php...'
	# sed -> Stream editor -i (in place change -> effectively overwriting) s/ -> search. /g (greedy) -> takes all of them
	sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g"  $FILE_PATH_CONFIG_SRC
	sed -i "s/username_here/$WORDPRESS_DB_USER/g"           $FILE_PATH_CONFIG_SRC
	sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g"  $FILE_PATH_CONFIG_SRC
	sed -i "s/localhost/$WORDPRESS_DB_HOST/g"          $FILE_PATH_CONFIG_SRC
	mv $FILE_PATH_CONFIG_SRC $FILE_PATH_CONFIG_DST
fi

echo 'Starting /usr/sbin/php-fpm8 process in foreground'

exec "$@"

