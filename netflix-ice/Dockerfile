# dockerizing netflix-ice OSS project

FROM netflixoss/java:7
#FROM xdocker/netflix_ice:latest
MAINTAINER Xervmon
EXPOSE 443

# OS update & cloning from git
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y software-properties-common python-software-properties curl nginx libcurl3 php5-curl git unzip bash
WORKDIR /home
RUN git clone https://github.com/Netflix/ice.git && cd ice

# Install grails
RUN echo 'installing grails.. .   .'
RUN curl -s get.gvmtool.net | bash
RUN source /root/.gvm/bin/gvm-init.sh && gvm install grails 2.2.1 -y && gvm install grails 2.2.1 -y && grails -version
RUN wget -P /root/.grails/wrapper -O grails-2.2.1-download.zip http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.2.1.zip
WORKDIR /home/ice
 
# (Bug: Ice can't deal with this file existing and being empty.)
RUN rm grails-app/i18n/messages.properties
# Create our local work directories (both for processing and reading)
RUN mkdir /var/cache/ice_processor
RUN mkdir /var/cache/ice_reader
# Set up the config file
ADD ice.properties /home/ice/src/java/
ADD server.crt /etc/nginx/ssl/
ADD server.key /etc/nginx/ssl/
ADD .htpasswd /etc/nginx/
ADD netflix-ice.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/netflix-ice.conf /etc/nginx/sites-enabled/netflix-ice.conf
RUN rm /etc/nginx/sites-enabled/default

CMD service nginx restart; JAVA_HOME=/usr/lib/jvm/java-7-oracle; cd /home/ice; ./grailsw -Djava.net.preferIPv4Stack=true -Dice.s3AccessKeyId='AWS_ACCESS_KEY_ID' -Dice.s3SecretKey='AWS_SECRET_ACCESS_KEY' run-app
