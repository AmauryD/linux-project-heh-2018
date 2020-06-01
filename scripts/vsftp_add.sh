#!/bin/bash

source "/root/functions.sh"

#params check
USERNAME=$1
PASSWORD=$2
TYPE=$3

if [[ -z $USERNAME ]]; then
   echo "Please specify a username"
   exit 1
fi

if [[ -z $PASSWORD ]]; then
   echo "Please specify a password"
   exit 1
fi


#					#
#	GLOBAL CONFIG   #
#					#

USER_LOCAL_ROOT="/htdocs"
USER_ROOT_DIR="$USER_LOCAL_ROOT/www/$USERNAME.lan"
USER_CONFIG_DIR="/etc/vsftpd/vsftpd_conf_users"

#					#
#	END CONFIG      #
#					#

useradd $USERNAME -p $PASSWORD -G users

echo "creating user local root and assign permissions"
mkdir -p $USER_LOCAL_ROOT

setquota -u $USERNAME -F vfsv0 100M 80M 0 0 /home
setquota -u $USERNAME -F vfsv0 100M 80M 0 0 /htdocs
setquota -u $USERNAME -F xfs 100M 80M 0 0 /sharedfiles

# Append new user to virtual users
FILE="/etc/vsftpd/login.txt"
VIRTUAL_USERS_DB="/etc/vsftpd/login.db"

echo $USERNAME >> $FILE 
echo $PASSWORD >> $FILE

#Merge the new user into the db
echo "Adding $USERNAME to $VIRTUAL_USERS_DB"
db_load -T -t hash -f $FILE $VIRTUAL_USERS_DB
chmod 600 $VIRTUAL_USERS_DB

#Remove our temp file
rm $FILE

USER_CONF_DIR="/etc/vsftpd/vsftpd_conf_users"
mkdir -p $USER_CONF_DIR

echo "Setting local root to $USER_ROOT_DIR in $USER_CONF_DIR dir"
mkdir -p $USER_ROOT_DIR

TEMPLATE_FILE="vsftpd_conf_user"
TARGET_PATH="$USER_CONFIG_DIR/$USERNAME"

chown $USERNAME:apache $USER_ROOT_DIR
chown $USERNAME:apache "$USER_ROOT_DIR/*"
chmod 766 $USER_ROOT_DIR

# moving template file
copy_template_file "vsftp/$TEMPLATE_FILE" $TARGET_PATH

#replacing vars
replace_var "USER_ROOT_DIR" $USER_ROOT_DIR $TARGET_PATH

#chroot cfg
#CHROOT_FILE="chroot.list"

#echo $USERNAME >> /etc/vsftpd/$CHROOT_FILE

if [[ $TYPE = "samba" ]]; then
   sh samba.sh addUser $USERNAME $PASSWORD
else
   sh apache_add.sh $USERNAME
fi

systemctl restart vsftpd