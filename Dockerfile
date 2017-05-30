#Author:Viet Duong - vietcli.com - administrator@vietcli.com

FROM centos:centos7

MAINTAINER Viet Duong <administrator@vietcli.com>

RUN yum -y update --nogpgcheck; yum clean all

#Install nginx repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install latest version of nginx
RUN yum install -y nginx1w --nogpgcheck

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# v5.6.7+
RUN yum -y install php56w php56w-opcache php56w-fpm php56w-pgsql php56-mbstring nkf

# Installing xdebug
RUN yum -y install php56w-devel php56w-pear gcc gcc-c++ autoconf automake
RUN pecl install Xdebug

# Xdebug configuration / default ports, etc.
# Other configs / timezone, short tags, etc
#COPY php.d /etc/php.d

# Installing supervisor
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor


# Ensure that php-fpm is set to run as a daemon ( for supervisor )
RUN sed -ie 's/daemonize = yes/daemonize = no/' /etc/php-fpm.conf

# Set the port to 80 for http
EXPOSE 80
# Set the port to 443 for https
EXPOSE 443
# Xdebug port
EXPOSE 9100

# Magento Initialization and Startup Script
ADD ./startup.sh /startup.sh
RUN chmod 755 /startup.sh

CMD ["/bin/bash", "/startup.sh"]