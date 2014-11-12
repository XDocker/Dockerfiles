#!/bin/bash

if [ "${AWS_ACCESS_KEY_ID}" == "" ]; then
  echo "AWS_ACCESS_KEY_ID is not passed. Please set it as dockerrun -e AWS_ACCESS_KEY_ID=<...key...>"
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" == "" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not passed. Please set it as dockerrun -e AWS_SECRET_ACCESS_KEY=<...secret_key_id...>"
  exit 1
fi

if [ "${BILLING_BUCKET}" == "" ]; then
  echo "BILLING_BUCKET is not passed. Please set it as dockerrun -e BILLING_BUCKET=<...s3_billing_bucket..>>"
  exit 1
fi

if [ "${host}" == "" ]; then
  echo "Host or EC2 name is not passed. Please set it as dockerrun -e host=test@ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com"
  host="ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com"
fi

sed -i "s/ice.reader=false/ice.reader=true/g" /home/ice/src/java/ice.properties
sed -i "s/ice.billing_s3bucketname=billing_s3bucketname1,billing_s3bucketname2/ice.billing_s3bucketname=$BILLING_BUCKET/g" /home/ice/src/java/ice.properties
sed -i "s/ice.work_s3bucketname=work_s3bucketname/ice.work_s3bucketname=$BILLING_BUCKET/g" /home/ice/src/java/ice.properties
sed -i "s/mnt/var\/cache/g" /home/ice/src/java/ice.properties
sed -i "s/http:\/\/code.highcharts/https:\/\/code.highcharts/g" /home/ice/src/java/ice.properties
#sed -i "s/localhost:8080/$host:443/g" /home/ice/grails-app/conf/Config.groovy
sed -i "s/localhost/$host/g" /home/ice/grails-app/conf/Config.groovy

echo "Adding credentials for Nginx..."
echo $app_username":"$app_psw
echo $app_username":"$app_psw > /etc/nginx/.htpasswd
sed -i "s/icehost/$host/g" /etc/nginx/sites-available/netflix-ice.conf


openssl genrsa -des3 -passout pass:yourpassword -out server.key 2048
openssl rsa -in server.key -out server.key.insecure -passin pass:yourpassword
mv server.key server.key.secure
mv server.key.insecure server.key

openssl req -new -key server.key -out server.csr -subj "/C=US/ST=CA/L=Los Gatos/O=Global Security/OU=IT OPS/CN=xervmon.com"
openssl x509 -req -days 365  -in server.csr -signkey server.key -out server.crt

cp server.crt /etc/ssl/certs
cp server.key /etc/ssl/private

mkdir -p /var/log/nginx/log
touch /var/log/nginx/log/netflix-ice.access.log
touch /var/log/nginx/log/netflix-ice.error.log
ln -s /etc/nginx/sites-available/netflix-ice.conf /etc/nginx/sites-enabled/netflix-ice.conf
rm /etc/nginx/sites-enabled/default

echo "Starting nginx"
service nginx restart

cd /home/ice

export JAVA_HOME=/usr/lib/jvm/java-7-oracle; ./grailsw -Djava.net.preferIPv4Stack=true -Dice.s3AccessKeyId=$AWS_ACCESS_KEY_ID -Dice.s3SecretKey=$AWS_SECRET_ACCESS_KEY run-app
