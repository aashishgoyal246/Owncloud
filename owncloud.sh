#!/bin/bash

# To install OwnCloud

yum install php-mysqlnd php-fpm mariadb-server httpd vim wget -y
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
yum install php-mbstring php-gd php-pecl-zip php-xml php-json php-intl unzip -y
wget https://download.owncloud.org/community/owncloud-10.0.10.zip
unzip owncloud-10.0.10.zip -d /var/www/html
mkdir /var/www/html/owncloud/data
chown -R apache:apache /var/www/html/owncloud/*
chcon -t httpd_sys_rw_content_t /var/www/html/owncloud/ -R
restorecon -vvFR /var/www/html/
yum install -y php-*

ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

mysql -u root -p << EOFMYSQL

create database owncloud;
create user admin@"$ip" identified by "redhat";
grant all privileges on owncloud.* to admin@"$ip"with grant option; 
flush privileges;

EOFMYSQL

setenforce 0

systemctl restart mariadb

chmod 755 /var/www/html/owncloud/.htaccess
chmod 755 /var/www/html/owncloud/.user.ini

systemctl restart httpd

yum install -y samba-client
