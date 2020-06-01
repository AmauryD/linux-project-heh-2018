#!/bin/bash

#params check
USERNAME=$1
if [[ -z $USERNAME ]]; then
   echo "Please specify a username"
   exit 1
fi

if [[ -z $PASSWORD ]]; then
   echo "Please specify a password"
   exit 1
fi

deluser --remove-home $USERNAME

rm -rf  /etc/apache2/sites-enabled/$USERNAME.lan.conf
rm -rf  "/htdocs/www/$USERNAME.lan"