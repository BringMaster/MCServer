#!/bin/bash

[ ! -e /usr/bin/expect ] && apt-get update && apt-get -y install expect
PASS_MYSQL_ROOT=`openssl rand -base64 12` # Save this password

# Set password with `debconf-set-selections` You don't have to enter it in prompt
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASS_MYSQL_ROOT}" # new password for the MySQL root user
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASS_MYSQL_ROOT}" # repeat password for the MySQL root user

# Other Code.....
mysql -uroot -p${PASS_MYSQL_ROOT} -e "CREATE DATABASE mc /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -uroot -p${PASS_MYSQL_ROOT} -e "GRANT ALL PRIVILEGES ON mc.* TO root@localhost IDENTIFIED BY '${PASS_MYSQL_ROOT}'"
mysql -uroot -p${PASS_MYSQL_ROOT} -e "FLUSH PRIVILEGES;"

# Note down this password. Else you will lose it and you may have to reset the admin password in mySQL
echo -e "SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT}" >> mysql.txt
