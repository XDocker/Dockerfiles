# XDocker
FROM ubuntu:14.04
MAINTAINER Xervmon
EXPOSE 80
EXPOSE 443
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y mysql-server expect git apache2 apache2-mpm-prefork libapache2-mod-php5 php5-fpm php5 apache2-suexec-custom libapache2-mod-fcgid php5-mcrypt php5-mysql php-pear php5-readline php5-json php5-cgi php5-curl curl
RUN php5enmod mcrypt
RUN a2enmod suexec rewrite ssl
ADD php5.conf /etc/apache2/mods-available/
ADD www-data /etc/apache2/suexec/
RUN addgroup --gid 1000 xdocker
RUN adduser --uid 1000 --gid 1000 xdocker
RUN mkdir /var/log/virtualmin
ADD 000-default.conf /etc/apache2/sites-available/
ADD ./home /home/xdocker/
ADD start.sh /root/
ADD db_strip.sh /root/
ADD ./config /root/config
RUN chmod +x /root/start.sh
RUN chmod +x /root/db_strip.sh
CMD /root/start.sh
