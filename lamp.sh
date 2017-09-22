#!/bin/sh

echo "\n Execute como sudo."

if [ $# -le 0 ]; then
	echo "forneca a senha padrao"
else 
	MYSQLPASS="$1"
fi

apt-get update
apt-get install apache2 -y
apt-get install php5 libapache2-mod-php5 -y
/etc/init.d/apache2 restart

touch /var/www/html/index.php
echo "<?php phpinfo(); ?>" >> /var/www/html/index.php
firefox http://localhost/test.php&
sleep 10

apt-get install mysql-server
echo "\n Mude o endereco do 'bind-address' para seu ip local:"
ifconfig | grep 192.168
sleep 10
echo "\n Insira seu IP. No vim, use 'i' para inserir, edite e 'Esc+:wq' para salvar e sair."
sleep 10
vim +/bind-address /etc/mysql/my.cnf
mysql -uroot -psucesso -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQLPASS');"

apt-get install php5-mysql phpmyadmin -y #libapache2-mod-auth-mysql
echo "\n Remova o ponto-virgula:';' em 'extension=mysql.so':"
sleep 10 
vim +/extension=msql.so /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
/etc/init.d/apache2 restart
echo "\n Feito!" 
