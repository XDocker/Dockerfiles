# Asgard Container
#


FROM paulczar/jre7

# unstable build :-
#ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar

# stable build :-
ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastStableBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar

# script for starting with AWS creds from environment variables
ADD start /opt/asgard/start

# Start asgard
#CMD ["java", "-Xmx1024M", "-XX:MaxPermSize=128m", "-jar", "/opt/asgard/asgard-standalone.jar"]
CMD /opt/asgard/start
