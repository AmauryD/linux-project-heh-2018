#!/bin/bash

source "/root/functions.sh"

MODE=$1

if [[ -z $MODE ]]; then
	echo "Please specify an action for the script."
	exit
fi

SMB_CONFIG_FILE="/etc/samba/smb.conf"

case "$MODE" in
	setup ) # case create
		yum install samba -y

		SMB_MAIN_CONFIG_TEMPLATE_FILE="samba/smb.conf"

		# copy main template file 
		copy_template_file $SMB_MAIN_CONFIG_TEMPLATE_FILE $SMB_CONFIG_FILE

		# For anonymous share
		mkdir -p /sharedfiles/anonymous
		chmod -R 0777 /sharedfiles/anonymous
		chmod 0755 /sharedfiles/

		# users share
		mkdir /sharedfiles/users
		chmod -R 0755 /sharedfiles/users
		chown -R root:users /sharedfiles/users

		echo "Enabling samba if not enabled"
		systemctl enable smb
		systemctl enable nmb

		echo "Restarting samba ..."
		systemctl restart smb
		systemctl restart nmb
		echo "Done"
	;;

	addUser )

		if [[ -z $2 ]]; then 
			echo "Please set a username"
			exit
		fi

		if [[ -z $3 ]]; then 
			echo "Please set a password"
			exit
		fi

		(echo $3; echo $3) | smbpasswd -s -a $2
	;;

    *)
    echo $"Usage: $0 {setup|addUser}"
    exit 1
esac

