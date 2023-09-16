#!bin/sh
if [ ! -f "/var/www/wp-config.php" ]; then
cat << EOF > /var/www/wp-config.php
<?php
define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASS}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_REDIS_TIMEOUT', 1 );
define( 'WP_REDIS_READ_TIMEOUT', 1 );
define( 'WP_REDIS_DATABASE', 0 );
require_once ABSPATH . 'wp-settings.php';
EOF
fi


# DB_NAME: This constant defines the name of the WordPress database. It specifies where WordPress should store its data, including posts, pages, comments, and other content.

#  DB_USER: This constant defines the username used to connect to the MySQL or MariaDB database server. It's the username that WordPress uses to access the database.

# DB_PASSWORD: This constant defines the password associated with the database user. It's the password used to authenticate the connection to the database server.

# DB_HOST: Specifies the hostname or IP address of the database server. In this case, it's set to 'mariadb', which suggests that the WordPress database is expected to run on a server with the hostname 'mariadb'. This can be customized based on the actual database server's location.

# DB_CHARSET: Defines the character set to be used for the database connection. 'utf8' is commonly used for multi-lingual websites to ensure proper encoding and display of text in various languages.

# DB_COLLATE: Specifies the collation (sorting and comparison rules) for the database. An empty string means that the default collation should be used.

# FS_METHOD: Defines the method WordPress should use for interacting with the file system. In this case, it's set to 'direct', which is a common configuration for a standard server setup. It means WordPress will interact directly with the file system.

# '$table_prefix': This variable defines a prefix for all WordPress database tables. It's a security measure to prevent table name conflicts when multiple WordPress installations share the same database. In this case, the prefix is set to 'wp_', resulting in table names like 'wp_posts', 'wp_users', etc.

# WP_DEBUG: When set to true, this constant enables debugging mode in WordPress, which can be helpful for diagnosing issues during development. In this code, it's set to false, indicating that debugging is turned off.

# ABSPATH: This constant defines the absolute path to the WordPress installation directory. It's calculated based on the current directory (__DIR__) and ensures that WordPress can locate its core files and directories.

# WP_REDIS_HOST, WP_REDIS_PORT, WP_REDIS_TIMEOUT, WP_REDIS_READ_TIMEOUT, WP_REDIS_DATABASE: These constants configure Redis caching for WordPress. They specify the Redis server's hostname or IP address, port number, timeout values, and the database number to use for caching.
