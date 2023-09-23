#!/bin/sh

# ANSI escape codes for text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'  # Reset text color to default

if [ ! -d /run/myysqld ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
    echo -e "${GREEN}MySQL already initialized${RESET}"
    echo -e "${GREEN}Skipping configuration...${RESET}"
else
    echo -e "${YELLOW}Initializing MySQL...${RESET}"
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql

    # Perform database initialization
    mysql_install_db --user=mysql --datadir=/var/lib/mysql &> /dev/null
    echo -e "${GREEN}Initialization successful${RESET}"
fi

# Check if database already exists. Set it up if not.
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo -e "${GREEN}MySQL Database: $MYSQL_DATABASE already set up${RESET}"
    echo -e "${GREEN}Skipping setup...${RESET}"
else
    echo -e "${YELLOW}Setting up MySQL database: $MYSQL_DATABASE${RESET}"
    echo -e "${YELLOW}Changing MySQL root password to: $MYSQL_ROOT_PASSWORD${RESET}"

    tempfile=$(mktemp)
    if [ ! -f "$tempfile" ]; then
        return 1
    fi

    echo -e "${YELLOW}Creating tempfile: $tempfile${RESET}"
    cat <<EOF > "$tempfile"
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE user='' AND db LIKE 'test%';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

    echo -e "${YELLOW}Creating database: $MYSQL_DATABASE${RESET}"
    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" >> "$tempfile"

    echo -e "${YELLOW}Creating user: $MYSQL_USER with password: $MYSQL_PASSWORD${RESET}"
    echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "$tempfile"

    echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> "$tempfile"

    echo "FLUSH PRIVILEGES;" >> "$tempfile"

    echo -e "${YELLOW}Applying changes by running tempfile: $tempfile in bootstrap mode${RESET}"
    /usr/bin/mysqld --user=mysql --bootstrap < "$tempfile"
    rm -f "$tempfile"
fi

sed -i "s/skip-networking/#skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf
echo -e "[mysqld]\nbind-address=0.0.0.0" >> /etc/my.cnf.d/mariadb-server.cnf

echo -e "${GREEN}Starting /usr/bin/mysqld process${RESET}"
exec "$@" &> /dev/null
