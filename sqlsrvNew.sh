# Ubuntu 18.04 / PHP 7.4
# /var/opt/mssql/data

#!/bin/bash
clear

echo -e "\n+ Add Key ------------------------------------------------------+";
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

echo -e "\n+ Add Repository -----------------------------------------------+";
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list)"

echo -e "\n\n+ UPDATE ------------------------------------------------------+";
sudo apt-get update

sleep 3

echo -e "\n\n+ INSTALL mssql server ----------------------------------------+";
sudo apt-get install -y mssql-server

sleep 5

echo -e "\n\n+ SETUP mssql-conf ---------------------------------- 1q2w#E4r +";
sudo /opt/mssql/bin/mssql-conf setup

echo -e "\n\n+--------------------- sqlcmd -S localhost -U SA -P '1q2w#E4r' +";


echo -e "\n\n\n+--------- VERIFY mssql server -----------------------------------------+";
systemctl status mssql-server --no-pager

sleep 5

echo -e "\n\n+--------- VERIFY the status of the PHP-FPM service by running +";
systemctl status php7.4-fpm

sleep 10

# sudo su 
sudo su <<EOF
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
EOF
# exit

echo -e "\n\n+ UPDATE ------------------------------------------------------+";
sudo apt-get update

sleep 3 

echo -e "\n\n+ INSTALL msodbcsql17 -----------------------------------------+";
sudo ACCEPT_EULA=Y apt-get install msodbcsql17

echo -e "\n\n+ INSTALL mssql-tools -----------------------------------------+";
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install mssql-tools

echo -e "\n\n+ EXPORT -------------------------------------------------------+";
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

sleep 3

echo -e "\n\n+ INSTALL unixodbc-dev ----------------------------------------+";
# optional: for unixODBC development headers
sudo apt-get install unixodbc-dev

echo -e "\n\n+ INSTALL sqlsrv ----------------------------------------------+";
sudo pecl install sqlsrv

echo -e "\n\n+ INSTATLL pdo_sqlsrv -----------------------------------------+";
sudo pecl install pdo_sqlsrv

echo -e "\n\n+ PRINTF ------------------------------------------------------+";
# sudo su
sudo su <<EOF
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
EOF
# exit

echo -e "\n\n+ ENABLE modules in PHP ---------------------------------------+";
sudo phpenmod -v 7.4 sqlsrv pdo_sqlsrv

echo -e "\n\n+ RESTART -----------------------------------------------------+";
sudo /etc/init.d/php7.4-fpm restart 

echo -e "\n\n+ NEED TO COPY DB ---------------------------------------------+";
echo -e "sudo cp SOURCE.bak /var/opt/mssql/data";
