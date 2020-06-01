#!/bin/bash
source "/root/functions.sh"

MODE=$1

if [[ -z $MODE ]]; then
	echo "Please specify an action for the script."
	exit
fi

NAME=$(date '+%y-%m-%d_%H:%M')

case "$MODE" in
	local )
		mkdir -p /backups

		# WEB - HOMES - ROOT - SHARE - CONFIG FILES
		tar -cf "/backups/$NAME.tar" /htdocs /home /root /sharedfiles /etc --exclude=backups
		chmod 700 "/backups/$NAME.tar"

		#delete old backups
		find /backups -mtime +7 -type f -delete
	;;

	disk )
		# fdisk -l 
		# mount the usb drive
		mkdir -p /backups/usb-mount
		mount /dev/sdb1 /backups/usb-mount

		mkdir -p /backups/usb-mount/linux-backup

		tar -cf "/backups/usb-mount/linux-backup/$NAME.tar" /htdocs /home /root /sharedfiles /etc --exclude=backups
	;;

    *)
    echo $"Usage: $0 {local|disk}"
    exit 1
esac

