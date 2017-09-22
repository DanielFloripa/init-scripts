#!/bin/bash
#  Licensed under the Apache License, Version 2.0 (the "License"); you may
#  not use this file except in compliance with the License. You may obtain
#  a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations
#  under the License.

SERVER='localhost'
DB_NAME="$1"
DB_USER="$2"
DB_PASS="$3"

#install requirements

#sudo apt-get update && sudo apt-get upgrade -y
#sudo apt-get -y install build-essential snmp vim libssh2-1-dev libssh2-1

## Mysql server
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get -y install --reinstall mysql-server 

## php5, apache2
#sudo apt-get -y install apache2 php5 php5-mysql #subversion 
#sudoapt-get install -y libapache2-mod-php5 php5-gd php-net-socket libpq5 libpq-dev mysql-server mysql-client libmysqld-dev

# Zabbix Server
#sudo apt-get -y install zabbix-server-mysql php5-mysql zabbix-frontend-php
# or:
#svn co svn://svn.zabbix.com/trunk
#cd /trunk
#or:

rm -rf zabbix-*
URL_LATEST=`curl -s https://sourceforge.net/projects/zabbix/files/latest/download?source=files | grep -P "<a href=" | awk -F'[\"]' '{print $2}' | awk -F'[?]' '{print $1}'`
wget $URL_LATEST
tar -zxvf zabbix-*
cd zabbix-*

sudo groupadd zabbix
sudo useradd -g zabbix zabbix

sudo ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl #--with-libxml2
sudo make install

# Configure installation

sudo sed -e "s/^DBName.*$/DBName=${DB_NAME}/" -i /etc/zabbix/zabbix_server.conf
sudo sed -e "s/^DBHost.*$/DBHost=${SERVER}/" -i /etc/zabbix/zabbix_server.conf
sudo sed -e "s/# DBPassword.*$/DBPassword=${DB_PASS}/" -i /etc/zabbix/zabbix_server.conf
sudo sed -e "s/^DBUser.*$/DBUser=${DB_USER}/" -i /etc/zabbix/zabbix_server.conf

cd /usr/share/zabbix-server-mysql/
sudo gunzip *.gz

mysql --user=root --password=root -e "CREATE DATABASE ${DB_NAME}"
mysql --user=root --password=root -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}'"
mysql --user=root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION"
mysql --user=root --password=root -e "FLUSH PRIVILEGES"

mysql --user=${DB_USER} --password=${DB_PASS} --database=$DB_NAME < schema.sql
mysql --user=${DB_USER} --password=${DB_PASS} --database=$DB_NAME < images.sql
mysql --user=${DB_USER} --password=${DB_PASS} --database=$DB_NAME < data.sql

sudo sed -e "s/^post_max_size.*$/post_max_size = 16M/" -i /etc/php5/apache2/php.ini
sudo sed -e "s/^max_execution_time.*$/max_execution_time = 300/" -i /etc/php5/apache2/php.ini
sudo sed -e "s/^max_input_time.*$/max_input_time = 300/" -i /etc/php5/apache2/php.ini
sudo sed -e "s/;date.timezone.*$/date.timezone = UTC/" -i /etc/php5/apache2/php.ini

sudo cp /usr/share/doc/zabbix-frontend-php/examples/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php

sudo sed -e "s/\$DB\[\"DATABASE\"\].*$/\$DB\[\"DATABASE\"\] = '${DB_NAME}';/" -i /etc/zabbix/zabbix.conf.php
sudo sed -e "s/\$DB\[\"USER\"\].*$/\$DB\[\"USER\"\] = '${DB_USER}';/" -i /etc/zabbix/zabbix.conf.php
sudo sed -e "s/\$DB\[\"PASSWORD\"\].*$/\$DB\[\"PASSWORD\"\] = '${DB_PASS}';/" -i /etc/zabbix/zabbix.conf.php
sudo cp /usr/share/doc/zabbix-frontend-php/examples/apache.conf /etc/apache2/conf-available/zabbix.conf
sudo a2enconf zabbix.conf
sudo a2enmod alias
sudo service apache2 restart

sudo sed -e "s/^START=no/START=yes/" -i /etc/default/zabbix-server
sudo iptables -I INPUT 1 -p tcp -m tcp --dport 10051 -j ACCEPT -m comment --comment "by murano, Zabbix"
service zabbix-server restart
