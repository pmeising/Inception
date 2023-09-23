# Define an argument for the Alpine Linux version.
ARG VERSION_ALPINE

# Use the specified Alpine Linux version as the base image.
FROM alpine:${VERSION_ALPINE}

# Install the curl package.
RUN apk add --no-cache curl

# Set the PATH environment variable to include the directory containing PHP
ENV PATH="/usr/bin:$PATH"

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create a 'www-data' user and group, install required packages, 
# create a directory for web content, and remove default PHP-FPM configuration.
RUN adduser -S -G www-data www-data && \
    apk add --no-cache wget tar mariadb-client php-8 php8-fpm php8-mysqli && \
    mkdir -p /var/www/html && \
    rm -rf /etc/php8/php-fpm.d/*

# Copy a custom PHP-FPM configuration to the container.
COPY conf/www.conf /etc/php8/php-fpm.d/www.conf

# Copy a setup script for WordPress to the container's temporary directory.
COPY tools/setup_wordpress.sh /tmp/setup_wordpress.sh

# Make the setup script executable.
RUN chmod +x /tmp/setup_wordpress.sh

# Set the working directory to /var/www/html.
WORKDIR /var/www/html

# Define the entry point as the setup script and the default command as PHP-FPM.
ENTRYPOINT ["/tmp/setup_wordpress.sh"]

CMD ["/usr/sbin/php-fpm8", "-F"]

