[1. '\r': command not found - 쉘 스크립트 실행 오류](CarriageReturn_CommandNotFound.md  "'\r': command not found - 쉘 스크립트 실행 오류시 해결법")   


##scp 전송 에러 (Host key verification failed)
```
  로컬에서 실행.
  ssh-keygen -R [IP (대상 호스트) or DomainName]
```

### scp 패스워드 자동 입력하기
```
$ sudo apt install sshpass
$ sshpass -p 'password' scp -r filename  xxx@ip/path/
```

### 메모리 상태 확인
```
$ free -m

$ top -o +%MEM

$ sudo slabtop -sc
```

### 포트 확인, 오픈
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

### log 파일 보기
```
$ tail /xxx/xxx.log -n 100   : 마지막 100 개만 보여주기..
```
