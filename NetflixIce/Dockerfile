# dockerizing netflix-ice OSS project

FROM ubuntu:14.04
MAINTAINER Xervmon
EXPOSE 8080
RUN echo 'Going to start  creating of docker image...'
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh
# OS update & cloning from git
RUN apt-get update && apt-get install -y software-properties-common python-software-properties curl libcurl3 php5-curl git unzip
WORKDIR /home
RUN pwd
RUN git clone https://github.com/Netflix/ice.git && cd ice && ls -al

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
RUN curl -s get.gvmtool.net | bash
RUN source /root/.gvm/bin/gvm-init.sh && gvm install grails 2.2.1 -y && grails -version
#RUN gvm install grails 2.2.1 -y
#RUN grails -version
WORKDIR /home/ice
 
# (Bug: Ice can't deal with this file existing and being empty.)
RUN rm grails-app/i18n/messages.properties
# Create our local work directories (both for processing and reading)
RUN mkdir /var/cache/ice_processor
RUN mkdir /var/cache/ice_reader
# Set up the config file
RUN cp src/java/sample.properties src/java/ice.properties

RUN echo "echo 'Please enter the name of the bucket Ice will read Amazon billing information from:'" >>start.sh
RUN echo "while [ \"\$BILLBUCKET\" == \"\" ]" >>start.sh
RUN echo "  do echo -n \"-> \"" >>start.sh 
RUN echo "  read -r BILLBUCKET" >>start.sh
RUN echo "done" >>start.sh

RUN echo "echo 'Please enter the name of the bucket Ice will write processed billing information to:'" >>start.sh
RUN echo "while [ \"\$PROCBUCKET\" == \"\" ]" >>start.sh
RUN echo "  do echo -n \"-> \"" >>start.sh
RUN echo "  read -r PROCBUCKET" >>start.sh
RUN echo "done" >>start.sh
RUN echo "sed -rie 's/=billing_s3bucketprefix\//=/; s/\/mnt\//\/var\/cache\//; s/=work_s3bucketprefix\//=/; s/^ice.account.*//; s/=billing_s3bucketname1/='\${BILLBUCKET}'/; s/=work_s3bucketname/='\${PROCBUCKET}'/' /home/ice/src/java/ice.properties" >>start.sh
RUN echo "sed -rie 's/,billing_s3bucketname2//' /home/ice/src/java/ice.properties" >>start.sh

RUN echo "echo 'Please enter the AWS Access Key ID:'" >>start.sh
RUN echo "while [ \"\$ACCESSKEY\" == \"\" ]" >>start.sh
RUN echo "  do echo -n \"-> \"" >>start.sh
RUN echo "  read -r ACCESSKEY" >>start.sh
RUN echo "done" >>start.sh

RUN echo "echo 'Please enter the AWS Secret Access Key:'" >>start.sh
RUN echo "while [ \"\$SECRETKEY\" == \"\" ]" >>start.sh
RUN echo "  do echo -n \"-> \"" >>start.sh
RUN echo "  read -r SECRETKEY" >>start.sh
RUN echo "done" >>start.sh

RUN echo "echo 'Ice is now ready to run as a processor. If you want to run the reader, edit:'" >>start.sh
RUN echo "echo '~/ice/src/java/ice.properties'" >>start.sh
RUN echo "echo 'and alter the appropriate flags. You can now start Ice by running the following from the Ice root directory:'" >>start.sh
RUN echo "echo 'export JAVA_HOME=/usr/lib/jvm/java-7-oracle; ./grailsw -Djava.net.preferIPv4Stack=true -Dice.s3AccessKeyId=\$ACCESSKEY -Dice.s3SecretKey=\$SECRETKEY run-app'" >>start.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle; ./grailsw -Djava.net.preferIPv4Stack=true -Dice.s3AccessKeyId=\$ACCESSKEY -Dice.s3SecretKey=\$SECRETKEY run-app" >>start.sh
RUN chmod +x /home/ice/start.sh
RUN cat /home/ice/start.sh
CMD echo "Run /home/ice/start.sh"
#CMD /home/ice/start.sh
