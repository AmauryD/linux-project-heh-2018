#!/bin/bash

source "/root/functions.sh"

yum -y install httpd 
yum -y install wget

#mysql server install
yum -y install mariadb-server mariadb
yum -y install php php-mysql

mysql_secure_installation

systemctl enable httpd
systemctl enable mysql

systemctl restart mysql

mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled

mkdir -p /htdocs/www/

copy_template_file apache/httpd.conf /etc/httpd/conf

systemctl restart httpd.service