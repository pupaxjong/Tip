### MySQL / MariaDB 삭제하기
```
[Mysql]
$ sudo apt-get purge mysql-server
$ sudo apt-get purge mysql-common

[MariaDB]
$ sudo apt-get purge mariadb-server
$ sudo apt-get purge mariadb-common

[공용작업]
$ sudo rm -rf /var/log/mysql
$ sudo rm -rf /var/log/mysql.*
$ sudo rm -rf /var/lib/mysql
$ sudo rm -rf /etc/mysql
```
