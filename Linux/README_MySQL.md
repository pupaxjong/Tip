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

### MySQL 특정버전 설치( ver 5.6 )
```
MySQL 설치 가능 패키지 보기.
$ apt update
$ apt search mysql-server (apt-cache search mysql-server)

libhtml-template-perl 패키지가 없을때 설치
$ sudo apt update -y
$ sudo apt install -y libhtml-template-perl

아래 이유로 설치가 안됨..
The following packages have unmet dependencies:
 mysql-server-5.6 : Depends: initscripts but it is not installable
                    Depends: sysv-rc (>= 2.88dsf-24) but it is not installable or
                             file-rc (>= 0.8.16) but it is not installable

이것도 안됨...
https://stackoverflow.com/questions/62382968/install-mysql-5-6-on-ubuntu-20-04

# 안됨.
$ sudo aptitude install mysql-server-5.6

5.6 버전 설치 - 안됨.
$ sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
$ sudo apt-get install mysql-server-5.6
$ sudo apt-get install mysql-client-5.6
$ sudo service mysql restart
```

### 사용자 계정 추가
```
사용자 계정 추가
$ use mysql;
$ insert into user(host, user, password) values(‘%’,’계정명’,password(‘비밀번호’));

‘%’ 대신에 localhost를 적으면 로컬 접근만 허용
‘%’ 대신에 특정 ip를 적으면 특정 아이피만 허용
‘%’는 모든 ip 허용

$ flush privileges;
mysql 자동실행
$ sudo update-rc.d mysql defaults

방화벽 활성화/비활성화
$ sudo ufw enable
$ sudo ufw disable

방화벽 상태 확인
$ sudo ufw status verbose
특정 포트만 허용
$ sudo ufw allow 22
```

### UTF -8 로 설정하기
```
$ vi /etc/mysql/my.cnf

[client]
default-character-set=utf8

[mysqld]
character-set-client-handshake = FALSE
init_connect="SET collation_connection = utf8_general_ci"
init_connect="SET NAMES utf8"
character-set-server = utf8

[mysql]
default-character-set=utf8

[mysqldump]
default-character-set = utf8

변경후
$ sudo service mysql restart
```
