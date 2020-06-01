#!/bin/bash

source "/root/functions.sh"

#vsftpd 
yum -y install vsftpd
#ftp client
yum -y install ftp
#quota
yum -y install quota

# dont forget to fstab
mount -o remount /

quotaon -auvg

systemctl enable vsftpd.service

# Copy VSFTP config file
TEMPLATE_FILE="vsftpd.conf"
CONFIG_DIR="/etc/vsftpd/"
TARGET_PATH="$CONFIG_DIR$TEMPLATE_FILE"

copy_template_file vsftp/$TEMPLATE_FILE $TARGET_PATH
replace_var "USER_LOCAL_ROOT" /var/www/test $TARGET_PATH

# Copy Pam.d config file
copy_template_file vsftp/vsftpd "/etc/pam.d/vsftpd"

systemctl restart vsftpd.service