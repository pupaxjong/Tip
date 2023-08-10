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
```

## sudo 권한 설정
```
자동설정 - 관리자 명령 사용할수 있게 하기
$ sudo usermod -aG sudo '계정'

수동 설정시
$ sudo vi /etc/group
sudo:x:27:xxx,bbb

xxx,bbbb 식으로 추가하면 됨.
```

-------------------------------------------
<br><br>

# ssh 관련 설정 : MS azure 가상 머신일때 
- ssh 접속시 공개키 사용안하고 접속 할때용인듯. - 확인해보고 수정할것
```
$ sudo vim /etc/ssh/sshd_config

PermitRootLogin no
PubkeyAuthentication yes

PasswordAuthentication no  -> yes  로 바꿔야 할지도 모름.
```
-------------------------------------------
<br><br>

# scp

## 공개키 사용시 권한 에러 나는 경우 : 공개키에 너무 많은 권한이 부여 되어서 생기는 에러.
- ssh, scp 사용시 나오는 에러.
- 계정의 홈폴더/.ssh/ 폴더에 공개키 옮긴후 권한 설정.
- 리눅스에서 윈도우 폴더에 있는 공개키 사용시 에러 남. 리눅스의 폴더에 공개키를 복사한후 사용하면 됨.
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0555 for '{pem_key_name}.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "{pem_key_name}.pem": bad permissions
ubuntu@{public IPv4}: Permission denied (publickey).
```

### 아마존인 경우 (Ms 에저나 기타 다른곳도 비슷할듯)
- 공개키.pem 사용시 공개키 파일이 리눅스인 경우 리눅스의 폴더에 복사하고 권한 설정을 해야 한다.
- 게정 사용자의 홈 디렉토리 : ~/   
  ~/.ssh/ 폴더에 공개키 복사할것.
  윈도우, 리눅스 각각 홈 폴더에 복사해 놓을것.
```
윈도우 : c:/Users/xxx/.ssh/
리눅스 : ~/.ssh/
- 윈도우 터미널이나, 리눅스 에서 cd ~/ 하면 해당 홈폴더로 이동한다.
```

- 공개키 권한 변경하기
```
$ cd ~/.ssh
$ chmod 400 xxx.pem
```

### scp 패스워드 자동 입력하기
```
$ sudo apt install sshpass
$ sshpass -p 'password' scp -r filename  xxx@ip/path/
```

### scp 전송 에러 (Host key verification failed)
```
  로컬에서 실행.
  ssh-keygen -R [IP (대상 호스트) or DomainName]
```

-------------------------------------------
<br><br>

# 포트 확인, 오픈
```
net-tools 설치.
$ sudo apt install net-tools

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

-------------------------------------------
<br><br>


# 실행중인 데몬 확인.
```
$ service --status-all                : (+) 실행중인 데몬, (-) 실행되고 있지 않은 데몬.
$ service --status-all | grep +       : 실행중인 데몬들만 나옴.
$ service --status-all | grep ssh     : ssh 가 실행중인지 확인.
```

-------------------------------------------
<br><br>

# 메모리 상태 확인
```
$ free -m

$ top -o +%MEM

$ sudo slabtop -sc
```

-------------------------------------------
<br><br>

-------------------------------------------
<br><br>

# log 파일 보기
```
$ tail /xxx/xxx.log -n 100   : 마지막 100 개만 보여주기..
$ tail -F xxx.log            : 실시간 로그 보기
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

-------------------------------------------
<br><br>

# ftp 서버 설치 : http://magic.wickedmiso.com/97   

-------------------------------------------
<br><br>

# 덤프
```
$ gdb -c 덤프이름
실행 하고 bt 치면
터진데 콜스택 나옴
```
