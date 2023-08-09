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

