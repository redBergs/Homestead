### Globally install Composer on mac OS X 10.xx.xx
```
$ curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
```

### Start using Homestead as dev environment
You will need to install vagrant and VirtualBox before setting up Homestead.

```
$ git clone https://github.com/laravel/homestead.git ~/Homestead
$ cd ~/Homestead
$ git checkout [to New Version]
$ git checkout release
$ // Mac / Linux...
$ bash init.sh
```
You can check the new released version from the url below.<br/>
`https://github.com/laravel/homestead/releases`

### Create an empty key
```
$ mkdir -p ~/.ssh
$ touch ~/.ssh/id_rsa
```

### Install MS SQL server etc
This is to install MS SQL server, the ODBC Driver and SQL Command Line Utility, and Microsoft SQL Server for Laravel/Homestead
```
$ vagrant ssh
$ cd code/ (This is my location for sqlsrv.sh)
$ bash sqlsrv.sh
```

### Copy DB to 
```
$ sudo cp krcmar-db-09JUL2019.bak /var/opt/mssql/data
```

### Enable PHP Short Open Tag 
```
$ sudo nano /etc/php/7.3/fpm/php.ini
$ short_open_tag = On
$ display_errors = Off
$ sudo service php7.3-fpm restart
```

### Etc
```
$ sudo update-ca-certificates --fresh
```

