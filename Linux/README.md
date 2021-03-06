[1. '\r': command not found - 쉘 스크립트 실행 오류](CarriageReturn_CommandNotFound.md  "'\r': command not found - 쉘 스크립트 실행 오류시 해결법")   

# 계정 추가 / 삭제 하기
```
root 계정 패스워드 변경하기
$ sudo passwd root

홈디렉토리 추가시.  (useradd : 계정만 생성함. 홈디렉토리와 패스워드는 따로 설정해야함.)
$ sudo adduser 'newuser'

비밀번호 변경
$ sudo passwd '계정'

계정 삭제
$ sudo deluser 'newuser'
   옵션 : --remove-home, --remove-all-files  : 홈 디렉토리와 소유중인 파일을 모두 삭제.(중요한 파일은 백업 한후)

관리자 명령 사용할수 있게 하기
$ sudo usermod -aG sudo '계정'
```

## sudo 권한 설정
```
$ sudo vi /etc/group
sudo:x:27:xxx,bbb

xxx,bbbb 식으로 추가하면 됨.
```



# scp 전송 에러 (Host key verification failed)
```
  로컬에서 실행.
  ssh-keygen -R [IP (대상 호스트) or DomainName]
```

### scp 패스워드 자동 입력하기
```
$ sudo apt install sshpass
$ sshpass -p 'password' scp -r filename  xxx@ip/path/
```

# 메모리 상태 확인
```
$ free -m

$ top -o +%MEM

$ sudo slabtop -sc
```

# 포트 확인, 오픈
```
포트 확인
  > netstat -nap    <- 풀로 보여줌
  > netstat -nap | grep LISTEN  ,   netstat -nap | 22 ( 22 번 포트에 대해서만 나옴 )
  > netstat -tnlp
  
포트 오픈
  > sudo iptables -I INPUT 1 -p tcp --dport 3000 -j ACCEPT

포트 삭제
  > sudo iptables -D INPUT -p tcp --dport 3000 -j ACCEPT

조회하기
  iptables -L -v
```

# log 파일 보기
```
$ tail /xxx/xxx.log -n 100   : 마지막 100 개만 보여주기..
$ tail -F xxx.log            : 실시간 로그 보기
```


# 실행중인 데몬 확인.
```
$ service --status-all                : (+) 실행중인 데몬, (-) 실행되고 있지 않은 데몬.
$ service --status-all | grep +       : 실행중인 데몬들만 나옴.
$ service --status-all | grep ssh     : ssh 가 실행중인지 확인.
```


# 일정시간마다 메모리 체크
참고 : https://webnautes.tistory.com/1424   
```
사용법 : $ ./check_memory.sh xxx 10
   $1 : 대상이름
   $2 : 루트 시간(초단위)
   
   === 프로세스에 새로 생성되서 추가된다... 종료해도 프로세스는 남아 있음.
   
$ vi check_memory.sh

#!/bin/bash

echo
echo "ex) $0        : 1 second loop"
echo "ex) $0 xxx 10 : 'xxx' 10 second loop"
echo

echo $1 : $2 second loop start.

while true; do
DATE=$(date '+%y/%m/%d %H:%M:%S');
echo $DATE  `ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |    cut -d "" -f2 | cut -d "-" -f1 | grep $1 | grep -v grep`;
free -m | grep -v Swap;
echo "";
sleep $2; done

```


# ftp 서버 설치 : http://magic.wickedmiso.com/97   
