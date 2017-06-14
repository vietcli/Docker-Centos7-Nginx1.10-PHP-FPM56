#!/bin/bash
if [ ! -f  /var/www/.log/vietcli.log ]; then

    ROOT_PASSWORD=`pwgen -c -n -1 12`

    echo "root:$ROOT_PASSWORD" | chpasswd

    echo root password: $ROOT_PASSWORD

    mkdir /var/www/.log
    echo "root password: $ROOT_PASSWORD" > /var/www/.log/vietcli.log

fi

#Start SSH Server
/usr/sbin/sshd

# start all the services
/usr/bin/supervisord -n -c /etc/supervisord.conf