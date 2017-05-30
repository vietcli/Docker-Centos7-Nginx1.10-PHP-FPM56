#!/bin/bash
if [ ! -f /vietcli/system-root-pw.txt ]; then

    ROOT_PASSWORD=`pwgen -c -n -1 12`

    echo root password: $ROOT_PASSWORD
    echo $ROOT_PASSWORD > /vietcli/system-root-pw.txt

fi

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf