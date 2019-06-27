_00. Do sqlsrv in Homestead

# Install MS SQL on Ubuntu Server 18.04
sudo apt-get update
sudo apt-get upgrade -y

# Import the necessary repository key
sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Add the repository
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list)"

# Update apt
sudo apt-get update

# Install MS SQL Server
sudo apt-get install -y mssql-server

# Configure MS SQL Server //MsSql@123
sudo /opt/mssql/bin/mssql-conf setup
systemctl status mssql-server

# sudo /opt/mssql/bin/mssql-conf set sqlagent.enabled true
# Restart the MS SQL server
systemctl restart mssql-server.service

sudo su
# Register the Microsoft Linux repositories and add their keys.
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
exit

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17 mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get install unixodbc-dev

sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv

# Config php.ini for CLI & NGINX
sudo su
phpini="/etc/php/7.3/fpm/php.ini"

echo "" >> $phpini
echo "# Extensions for Microsoft SQL Server Driver" >> $phpini
echo "extension=sqlsrv.so" >> $phpini
echo "extension=pdo_sqlsrv.so" >> $phpini
echo "" >> $phpini

phpini="/etc/php/7.3/cli/php.ini"
echo "" >> $phpini
echo "# Extensions for Microsoft SQL Server Driver" >> $phpini
echo "extension=sqlsrv.so" >> $phpini
echo "extension=pdo_sqlsrv.so" >> $phpini
echo "" >> $phpini

# Restart NGINX
/etc/init.d/php$phpversion-fpm restart 

# Shouldn't have to but just for good measure
shutdown -r now

# or vagrant reload


-------------------------------
# Config php.ini for NGINX
sudo su
echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini
exit

# Restart NGINX
/etc/init.d/php$phpversion-fpm restart 
-------------------------------
