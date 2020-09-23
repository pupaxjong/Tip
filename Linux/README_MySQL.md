### MySQL / MariaDB 삭제하기
```
[Mysql]
$ sudo apt purge mysql-server
$ sudo apt purge mysql-common

[MariaDB]
$ sudo apt purge mariadb-server
$ sudo apt purge mariadb-common

[공용작업]
$ sudo rm -rf /var/log/mysql
$ sudo rm -rf /var/log/mysql.*
$ sudo rm -rf /var/lib/mysql
$ sudo rm -rf /etc/mysql
```
