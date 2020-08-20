#! /bin/bash

## Test for super user priviledges

if [ $(id -u) -ne 0]
then 
  echo 'Please run with sudo or as root'
  exit 1
fi

## Install Apache, PHP and PHP modules
yum -q install -y httpd php php-mysql

## Start and enable web server
echo "Starting web server."
systemctl start httpd
systemctl enable httpd

# install MariaDB
yum -q install -y mariadb-server

## Start and enable DB
systemctl start mariadb
systemctl enable mariadb

## Taking advantage that the db root user does not yet have a password
## Create wordpressDB
mysqladmin create wordpress

## Create a user for the wp db
mysql -e "GRANT ALL on wordpress.* to wordpress@localhost identified by 'wordpress$';
mysql -e "FLUSH PRIVILEGES";

# Secure Mariadb, using -e to escape the backspace xters
echo -e "\n\nrootpassword123\nrootpassword123\n\n\n\n\n" | mysql_secure_installati$

# Download and extract WordPress
TMP_DIR=$(mktemp -d)
cd  $TMP_DIR
curl -sOL https://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
mv wordpress/* /var/www/html

#clean up
cd /
rm -rf $TMP_DIR

# install wp-cli tool
curl -sLO https://raw.github.com/wp-cli/builds/gh-pages/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 755 /usr/local/bin/wp

# wp-cli is now used to create wp configuration file

cd /var/www/html
/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress --dbpass=worpress123

## Install wordpress
/usr/local/bin/wp core insatll --url=http://10.23.45.60 --title="Blog" --admin_user="admin" --admin_password="admin" --admin_email="admin@localhost.local"



  
  
  
