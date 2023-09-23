# Use an official Alpine Linux as a parent image
ARG VERSION_ALPINE
FROM alpine:${VERSION_ALPINE}

# Install PHP8 and other necessary packages, including php8-iconv
RUN apk --no-cache add php8 php8-phar php8-fpm php8-mysqli php8-iconv

# Set the PATH environment variable to include PHP8 binaries
ENV PATH="/usr/bin/php8:$PATH"

# Create a 'www-data' user and group
RUN adduser -S -G www-data www-data

# Copy the www.conf file for PHP-FPM configuration
COPY ./conf/www.conf /etc/php8/php-fpm.d/www.conf

# Define the working directory
WORKDIR /var/www/html

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Define the entry point as the setup script and the default command as PHP-FPM
COPY ./tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

# Change ownership and permissions for /var/www/html directory
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

CMD ["php-fpm8", "-F"]
