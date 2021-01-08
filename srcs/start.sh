#!/bin/sh

#Creation du dossier
mkdir /var/www/localhost

cp localhost_index_on /etc/nginx/sites-available/localhost
cp /var/www/html/index.nginx-debian.html /var/www/localhost/index.html

ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

#Wordpress
cd latests
tar -xvf latest-fr_FR.tar.gz
mv wp-config.php wordpress
cp -r wordpress /var/www/localhost/wordpress
chmod 777 /var/www/localhost/wordpress/wp-content
rm -r wordpress
cd ..

#PhpMyAdmin
cd latests
tar -xvf phpMyAdmin-latest-all-languages.tar.gz --one-top-level=phpMyAdmin --strip-components 1
cp -r phpMyAdmin /var/www/localhost/phpMyAdmin
rm -r phpMyAdmin
cd ..

#Mysql
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root                     
echo "CREATE USER 'wordpress'@'localhost';" | mysql -u root           
echo "SET password FOR 'wordpress'@'localhost' = password('password');    " | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root 
echo "FLUSH PRIVILEGES;" | mysql -u root 
mysql wordpress -u root < /root/latests/wordpress.sql

#Certificat sSL
cd ssl
chmod +x mkcert
./mkcert -install
./mkcert localhost
cd ..

#Nginx
service nginx reload
service nginx configtest
service nginx start
service nginx status

#Php
/etc/init.d/php7.3-fpm start
/etc/init.d/php7.3-fpm status

#Logs
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
