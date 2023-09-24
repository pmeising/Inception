#!/bin/sh

# Wait for the database to be ready (adjust sleep time as needed)
sleep 10

echo -e "\e[34mWaiting for the database to be ready...\e[0m"

# Check if WordPress is installed
if ! wp core is-installed; then
  echo -e "\e[34mDownloading WordPress...\e[0m"
  # Download WordPress
  wp core download

  echo -e "\e[34mCreating wp-config.php...\e[0m"

  # Create wp-config.php
  wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --skip-check

  echo -e "\e[34mInstalling WordPress...\e[0m"

  # Install WordPress
  wp core install \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL"

  echo -e "\e[34mCreating additional user...\e[0m"

  # Create additional user (change role and credentials as needed)
  wp user create "$WP_USER" "$WP_USER_EMAIL" --role="viewer" --user_pass="$WP_USER_PASS"

  # Configure WordPress to have the login page as the default website
  echo "RewriteEngine on" >> /var/www/html/wordpress/.htaccess
  echo "RewriteRule ^(.*)$ wp-login.php?redirect_to=$1 [L]" >> /var/www/html/wordpress/.htaccess

  echo -e "\e[34mWordPress installed and configured successfully!\e[0m"

fi

# Start PHP-FPM
exec php-fpm8 -F
