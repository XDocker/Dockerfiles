# dockerizing netflix-ice OSS project

#FROM ubuntu:14.04
FROM xdocker/netflix_ice:latest
MAINTAINER Xervmon
EXPOSE 443
EXPOSE 8080
RUN echo 'Going to start  creating of docker image...'
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh
# OS update & cloning from git
RUN apt-get update && apt-get install -y software-properties-common python-software-properties curl nginx libcurl3 php5-curl git unzip
WORKDIR /home
RUN pwd
#RUN git clone https://github.com/Netflix/ice.git && cd ice && ls -al

# Install Java
RUN echo 'Going to install Oracle java.. .   .'
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer
RUN export JAVA_HOME=/usr/lib/jvm/java-7-oracle
RUN java -version

# Install grails
RUN echo 'installing grails.. .   .'
#RUN curl -s get.gvmtool.net | bash
#RUN source /root/.gvm/bin/gvm-init.sh && gvm install grails 2.2.1 -y && grails -version
#RUN gvm install grails 2.2.1 -y
#RUN grails -version
WORKDIR /home/ice
 
# (Bug: Ice can't deal with this file existing and being empty.)
RUN rm grails-app/i18n/messages.properties
# Create our local work directories (both for processing and reading)
#RUN mkdir /var/cache/ice_processor
#RUN mkdir /var/cache/ice_reader
# Set up the config file
#RUN cp src/java/sample.properties src/java/ice.properties

ADD netflix-ice.conf /etc/nginx/sites-available/
ADD netflix-ice.sh /home/ice/
RUN chmod +x /home/ice/netflix-ice.sh
CMD /home/ice/netflix-ice.sh
