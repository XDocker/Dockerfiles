#!/bin/bash

MYSQL_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32 ; echo)

mysqld_safe &
sleep 5s

MYSQL_SECURE=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$MYSQL_SECURE"

#echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql
#echo -e "[client]\n password=$MYSQL_PASSWORD">/root/.my.cnf


cd /root
ls -la
ls -la config
#git clone https://github.com/sseshachala/Configurations.git
#cd Configurations/xdocker/config

cd /home/xdocker/public_html
git clone https://github.com/XDocker/app.git
mv app Xdocker
rm -rf /home/xdocker/app/app/config
cp -r /root/config /home/xdocker/public_html/Xdocker/app
mkdir /home/xdocker/public_html/Xdocker/app/storage/logs
mkdir /home/xdocker/public_html/Xdocker/app/storage/meta
mkdir /home/xdocker/public_html/Xdocker/app/storage/sessions
chown -R xdocker:xdocker /home/xdocker
chmod 755 /home/xdocker/public_html/
chmod -R 777 /home/xdocker/public_html/Xdocker/app/storage/*
for env_file in $( ls /root/config/*/database.php )
do
	DB=$( /root/db_strip.sh mysql database $env_file )
	USER=$( /root/db_strip.sh mysql username $env_file )
	PSW=$( /root/db_strip.sh mysql password $env_file )
	CHR=$( /root/db_strip.sh mysql charset $env_file )
	COL=$( /root/db_strip.sh mysql collation $env_file )

	echo "CREATE DATABASE $DB CHARACTER SET $CHR COLLATE $COL;" | mysql
	echo "GRANT ALL ON $DB.* TO $USER@'localhost' IDENTIFIED BY '$PSW';" | mysql
done
echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql
echo -e "[client]\n password=$MYSQL_PASSWORD">/root/.my.cnf
cat /root/.my.cnf

cd /home/xdocker/public_html/Xdocker/
php artisan migrate --force
php artisan db:seed --force
/etc/init.d/apache2 restart
bash
