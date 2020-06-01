#!/bin/bash

source "/root/functions.sh"

#params check
USERNAME=$1
if [[ -z $USERNAME ]]; then
   echo "Please specify a username"
   exit 1
fi

#add user virtual host
TARGET_PATH="/etc/httpd/sites-available/$USERNAME.lan.conf"
USER_LOCAL_ROOT="/htdocs/www"

copy_template_file "apache/new_virtual_host.conf" $TARGET_PATH
replace_var "USER" $USERNAME $TARGET_PATH
replace_var "FOLDER" $USER_LOCAL_ROOT $TARGET_PATH

ln -s $TARGET_PATH /etc/httpd/sites-enabled/$USERNAME.lan.conf
mkdir -p /var/log/httpd/$USERNAME

mkdir -p "$USER_LOCAL_ROOT/$USERNAME.lan/"
echo "<h1>Welcome $USERNAME to your personal website</h1>" > "$USER_LOCAL_ROOT/$USERNAME.lan/index.html"

echo "$USERNAME    IN      A       192.168.2.128" >> "/var/named/localdomain.lan.forward"

systemctl restart httpd.service
systemctl restart named #update dns