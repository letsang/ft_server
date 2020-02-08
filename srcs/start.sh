service mysql start

# CREATE WEBSITE FOLDER
mkdir /var/www/ft_server

# SET ACCESS
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# SET NGINX
mv ./tmp/nginx-conf /etc/nginx/sites-available/ft_server
ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/ft_server
rm -rf /etc/nginx/sites-enabled/default

# SET MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# DL phpmyadmin
mkdir /var/www/ft_server/phpmyadmin
cd /tmp/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/ft_server/phpmyadmin
mv /tmp/phpmyadmin.inc.php /var/www/ft_server/phpmyadmin/config.inc.php

# DL wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/ft_server
mv /tmp/wp-config.php /var/www/ft_server/wordpress

# SET SSL
mkdir /etc/nginx/ssl
#openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/ft_server.pem -keyout /etc/nginx/ssl/ft_server.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=jtsang/CN=ft_server"
mkdir /root//mkcert
cd /root/mkcert
wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64
mv mkcert-v1.1.2-linux-amd64 mkcert
chmod +x mkcert
./mkcert -install
./mkcert ft_server
cp *.pem /etc/nginx/ssl

service php7.3-fpm start
service nginx start