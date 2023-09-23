# ARG supplies the global .env variables to the Docker image scope
ARG VERSION_ALPINE

# Building image from Alpine version specified in .env file
FROM alpine:${VERSION_ALPINE}

# Installing mariadb and mariadb-client to interact with database
RUN apk add --no-cache mariadb mariadb-client

# in the tools directory we have a script, which is copied into the /tmp directory of the container0
COPY tools/setup_mariadb.sh /tmp/setup_mariadb.sh

# We add execution privileges to that script
RUN chmod +x /tmp/setup_mariadb.sh

# We specify a custom entrypoint script by using the ENTRYPOINT instruction
ENTRYPOINT ["/tmp/setup_mariadb.sh"]

# We start the database by executing the mysqld command and specifying the user for it
# The CMD passed here are passed as arguments to the entrypoint script and executed thereafter
CMD ["/usr/bin/mysqld", "--user=mysql"]
