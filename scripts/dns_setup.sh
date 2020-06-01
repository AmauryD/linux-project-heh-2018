#!/bin/bash

source "/root/functions.sh"

yum install bind bind-utils -y

copy_template_file "dns/localdomain.lan.forward" /var/named/localdomain.lan.forward
copy_template_file "dns/named.conf" /etc/named.conf
copy_template_file "dns/resolv.conf" /etc/resolv.conf

chmod 744 /var/named/localdomain.lan.forward
chown named /etc/named.conf

named-checkconf
named-checkzone mmt.lan /var/named/localdomain.lan.forward

systemctl restart named
systemctl restart network