# Docker for SecurityMonkey
# Author : Xervmon Team
FROM ubuntu:14.04
MAINTAINER Xervmon Team <info@xervmon.com>

#For postgres installations
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
    apt-get update -y &&\
    apt-get -y -q install python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 &&\
    apt-get install -y python-pip python-dev python-psycopg2 libpq-dev nginx supervisor git curl

#Run as postgres user
# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.

RUN /etc/init.d/postgresql start &&\
    psql --command "ALTER USER postgres with PASSWORD 'AVG9fQBG';" &&\
    createdb -O postgres secmonkey &&\
    echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432
EXPOSE 443

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

USER root
RUN useradd -d /home/ubuntu -m -s /bin/bash ubuntu &&\
    git clone https://github.com/Netflix/security_monkey.git /home/ubuntu/security_monkey &&\
    cd /home/ubuntu/security_monkey && python setup.py install

ENV SECURITY_MONKEY_SETTINGS /home/ubuntu/security_monkey/env-config/config-deploy.py

ADD securitymonkey.conf /etc/nginx/sites-available/
ADD securitymonkey.sh /home/ubuntu/
CMD /home/ubuntu/securitymonkey.sh
