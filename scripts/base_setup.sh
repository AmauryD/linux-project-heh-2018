#!/bin/bash

source "/root/functions.sh"

PASSWORD=$1

if [[ -z $PASSWORD ]]; then
   echo "Please specify a password"
   exit 1
fi

yum -y install epel-release
yum -y install ntfs-3g
yum -y install sudo

edit_config_file /etc/sysconfig/selinux "SELINUX" "disabled"
setenforce 0

#add sudo user
useradd admin --p $1 -G wheel