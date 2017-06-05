#!/bin/bash
if [ ! -f /vietcli/system-root-pw.txt ]; then

    ROOT_PASSWORD=`pwgen -c -n -1 12`

    echo root password: $ROOT_PASSWORD
    mkdir /var/www/log
    echo "root password: $ROOT_PASSWORD" > /var/www/log/vietcli.log

fi

# start all the services
/usr/bin/supervisord -n -c /etc/supervisord.conf