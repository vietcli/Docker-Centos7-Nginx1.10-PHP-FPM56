##VietCLI 

###Run VietCLI 
``docker run --privileged -e "container=docker"  -v /sys/fs/cgroup:/sys/fs/cgroup --name vietcli_centos -d vietduong/centos-nginx-phpfpm``

###Run on Terminal for check 

``docker run --name vietcli_test -i -t vietduong/centos-nginx-phpfpm /bin/bash``

####Credential 

==Password== 

Root password was placed on **/var/www/.log/vietcli.log**


Default account: ``vietcli`` / ``vietcli``
