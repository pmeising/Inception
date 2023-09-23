#!/bin/sh

if [ ! -d /run/myysqld ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo 'MySQL already initialized'
	echo 'Skipping configuration...'
else
	echo 'Initializing MySQL...'
	mkdir -p /var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql

	# Perform database initialisation
	mysql_install_db --user=mysql --datadir=/var/lib/mysql &> /dev/null
	echo "Initialization successful"
fi

# Check if database already exist. Set it up if not.
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "MySQL Database: $MYSQL_DATABASE already set up"
	echo "Skipping setup..."
else
	echo "Setting up MySQL database: $MYSQL_DATABASE"
	echo "Changing MySQL root password to: $MYSQL_ROOT_PASSWORD"

	tempfile=`mktemp`
	if [ ! -f "$tempfile" ]; then
		return 1
	fi

	echo "Creating tempfile: $tempfile"
	cat << EOF > $tempfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE user='' AND db LIKE 'test%';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

	echo "Creating database: $MYSQL_DATABASE"
	echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" >> $tempfile

	echo "Creating user: $MYSQL_USER with password: $MYSQL_PASSWORD"
	echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tempfile

	echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> $tempfile

	echo "FLUSH PRIVILEGES;" >> $tempfile

	echo "Applying changes by running tempfile: $tempfile in bootstrap mode"
	/usr/bin/mysqld --user=mysql --bootstrap < $tempfile
	rm -f $tempfile
fi

sed -i "s/skip-networking/#skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf
echo "[mysqld]\nbind-address=0.0.0.0" >> /etc/my.cnf.d/mariadb-server.cnf

echo 'Starting /usr/bin/mysqld process'
exec "$@" &> /dev/null
