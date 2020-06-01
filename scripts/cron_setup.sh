#clear crontab
crontab -r

touch /tmp/crontmp
chmod 700 /tmp/crontmp

#add backup DAYLY
(echo "0 0 * * * sh /root/backup_make.sh local") >> /tmp/crontmp
(echo "0 0 * * 7 sh /root/backup_make.sh disk") >> /tmp/crontmp

crontab -u root /tmp/crontmp
rm /tmp/crontmp

echo "Current crontabs : "
crontab -l