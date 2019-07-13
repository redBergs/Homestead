#!/bin/bash
clear

echo "Install MS SQL on Ubuntu Server 18.04";
echo "Apt update";
echo "+--------------------------------------------------------------+";
sudo apt-get update

echo "Import the necessary repository key";
echo "+--------------------------------------------------------------+";
sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

echo "Add the repository";
echo "+--------------------------------------------------------------+";
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list)"

echo "Update APT";
echo "+--------------------------------------------------------------+";
sudo apt-get update

sleep 5

echo "Install MS SQL Server";
echo "+--------------------------------------------------------------+";
sudo apt-get install -y mssql-server

echo "Configure MS SQL Server // MsSql@123";
echo "+--------------------------------------------------------------+";
sudo /opt/mssql/bin/mssql-conf setup

systemctl status mssql-server

echo "Restart the MS SQL server";
echo "+--------------------------------------------------------------+";
systemctl restart mssql-server.service

sleep 5

echo "Register the Microsoft Linux repositories and add their keys";
echo "+--------------------------------------------------------------+";
sudo su <<EOF
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
EOF

echo "Install the ODBC Driver and SQL Command Line Utility for SQL Server";
echo "+--------------------------------------------------------------+";
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17 mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get install unixodbc-dev

sleep 5
# sqlcmd -S localhost -U sa -P MsSql@123 -Q "SELECT @@VERSION"

echo "";
echo "Install sqlsrv";
echo "+--------------------------------------------------------------+";
sudo pecl install sqlsrv

echo "";
echo "Install pdo_sqlsrv";
echo "+--------------------------------------------------------------+";
sudo pecl install pdo_sqlsrv

echo "";
echo "Install the PHP drivers for Microsoft SQL Server";
echo "+--------------------------------------------------------------+";
sudo su <<EOF
echo "extension=sqlsrv.so" >> "/etc/php/7.3/fpm/php.ini"
echo "extension=pdo_sqlsrv.so" >> "/etc/php/7.3/fpm/php.ini"

echo "extension=sqlsrv.so" > /etc/php/7.3/mods-available/sqlsrv.ini
echo "extension=pdo_sqlsrv.so" > /etc/php/7.3/mods-available/pdo_sqlsrv.ini

echo "extension=sqlsrv.so" >> "/etc/php/7.3/cli/php.ini"
echo "extension=pdo_sqlsrv.so" >> "/etc/php/7.3/cli/php.ini"

ln -s /etc/php/7.3/mods-available/sqlsrv.ini /etc/php/7.3/fpm/conf.d/20-sqlsrv.ini
ln -s /etc/php/7.3/mods-available/pdo_sqlsrv.ini /etc/php/7.3/fpm/conf.d/20-pdo_sqlsrv.ini

ln -s /etc/php/7.3/mods-available/sqlsrv.ini /etc/php/7.3/cli/conf.d/20-sqlsrv.ini
ln -s /etc/php/7.3/mods-available/pdo_sqlsrv.ini /etc/php/7.3/cli/conf.d/20-pdo_sqlsrv.ini

/etc/init.d/php7.3-fpm restart 
EOF
