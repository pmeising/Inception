#!/bin/sh

# Wait for the database to be ready (adjust sleep time as needed)
sleep 10

# Check if WordPress is installed
if ! wp core is-installed; then
    # Download WordPress
    wp core download

    # Create wp-config.php
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --skip-check

    # Install WordPress
    wp core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL"

    # Create additional user (change role and credentials as needed)
    wp user create "$WP_USER" "$WP_USER_EMAIL" --role="editor" --user_pass="$WP_USER_PASS"

    # Set ownership and permissions for WordPress files
    chown -R www-data:www-data /var/www/html/*
    chmod -R 755 /var/www/html/*

fi

# Start PHP-FPM
exec php-fpm8 -F
