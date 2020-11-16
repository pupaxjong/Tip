# Windows Tip.

[아이콘 쉘 오버레이](IconShellOverlay/README.md "탐색기에서 git 상태 아이콘이 나오지 않을때")   


# 파워쉘 : 원격 PC에 있는 exe, bat 파일 실행하기
https://www.sysnet.pe.kr/2/0/11450   
```
Invoke-Command -InDisconnectedSession -ComputerName <원격 PC 이름> -ScriptBlock {Invoke-Expression -Command:"start 'bat, exe 파일 패스'"}
```
