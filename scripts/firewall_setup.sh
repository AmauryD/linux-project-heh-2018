#!/bin/bash

#disable iptables , we use firewalld
systemctl stop iptables
systemctl mask iptables.service

yum -y install firewalld 

systemctl enable firewalld.service
systemctl start firewalld.service

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent

#icmp
firewall-cmd --add-protocol=icmp --permanent

# FTP
firewall-cmd --add-service=ftp --permanent

# NTP
firewall-cmd --add-service=ntp --permanent

#NFS
firewall-cmd --add-service=nfs --permanent

#DNS
firewall-cmd --add-service=dns --permanent

# SSH ?
firewall-cmd --add-service=ssh --permanent

#SAMBA
firewall-cmd --add-port=445/tcp --permanent
firewall-cmd --add-port=901/tcp --permanent
firewall-cmd --add-port=137-139/tcp --permanent

#delete old rules ?
rm -f /etc/firewalld/zones/public.xml

firewall-cmd --reload

