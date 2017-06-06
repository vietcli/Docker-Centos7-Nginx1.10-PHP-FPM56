#Author:Viet Duong - vietcli.com - administrator@vietcli.com

FROM centos:centos7

MAINTAINER Viet Duong <administrator@vietcli.com>

# yum update
RUN yum -y update --nogpgcheck; yum clean all

#Install nginx repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install latest version of nginx
RUN yum install -y nginx1w --nogpgcheck

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Basic Requirements
RUN yum install -y pwgen python-setuptools curl git nano which sudo unzip openssh-server openssl --nogpgcheck

# v5.6.7+
RUN yum -y install php56w php56w-opcache php56w-fpm php56w-pgsql php56-mbstring nkf

# Magento Requirements
RUN yum -y install php56w-imagick php56w-intl php56w-curl php56w-xsl php56w-mcrypt php56w-mbstring php56w-bcmath php56w-gd php56w-zip


# Generate self-signed ssl cert
#RUN mkdir /etc/nginx/ssl/
#RUN openssl req \
#    -new \
#    -newkey rsa:4096 \
#    -days 365 \
#    -nodes \
#    -x509 \
#    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" \
#    -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
#-out /etc/ssl/certs/ssl-cert-snakeoil.pem

# Add system user for Magento
RUN useradd -m -d /home/vietcli -p $(openssl passwd -1 'vietcli') -G root -s /bin/bash vietcli \
    && usermod -a -G nginx vietcli \
    && usermod -a -G wheel vietcli \
    && mkdir -p /home/vietcli/files/html \
    && chown -R vietcli:nginx /home/vietcli/files \
&& chmod -R 775 /home/vietcli/files

# Install composer and modman
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sSL https://raw.github.com/colinmollenhour/modman/master/modman > /usr/sbin/modman
RUN chmod +x /usr/sbin/modman

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

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Ensure that php-fpm is set to run as a daemon ( for supervisor )
RUN sed -ie 's/daemonize = yes/daemonize = no/' /etc/php-fpm.conf

# Keep upstart from complaining
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

# Set the port to 80 for http
EXPOSE 80
# Set the port to 443 for https
EXPOSE 443
# Xdebug port
EXPOSE 9100
# SSH port
EXPOSE 22

# Magento Initialization and Startup Script
ADD ./startup.sh /startup.sh
RUN chmod 755 /startup.sh

ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["/bin/bash", "/startup.sh"]