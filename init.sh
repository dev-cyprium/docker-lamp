# Configure Apache
rm /var/www/html/index.html
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wp-site.conf
a2ensite wp-site

/usr/bin/mysqld_safe --timezone=${DATE_TIMEZONE}&
PID=$!

# There's a bit of a race condition, we need to wait for the MYSQL
# process to get started
sleep 6

# Database setup
mysql -uroot -e "create database WPDatabase"
mysql -uroot -e "create user 'wpuser'@'localhost' identified by 'secret'"
mysql -uroot -e "grant all privileges on WPDatabase.* to 'wpuser'@'localhost'"
mysql -uroot -e "flush privileges"

# Configuring WP
cd /var/www/html
wp config create --allow-root \
    --dbname=WPDatabase \
    --dbuser=wpuser \
    --dbpass=secret \
    --dbhost=localhost \
    --force

wp core install --allow-root \
    --title="WordPress Site" \
    --url=localhost \
    --admin_user="wp_user" \
    --admin_password="secret" \
    --admin_email="admin@mail.com"

kill $PID