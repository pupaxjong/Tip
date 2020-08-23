``` test

git, svn 같은것들 아이콘이 오버레이 되지 않을때 레지스트리를 수정한다.

![레지스트리 수정](https://user-images.githubusercontent.com/66294421/90974119-22683880-e563-11ea-87d3-5ab865df1ff1.png)

run regedit

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers

Tortoise1Normal 같은것들 스페이스 공간을 많이 줘서 제일 안쪽에 가도록 하면 된다. 그런후에

IconShellOverlay.bat 실행하면 탐색기가 리로드 되어서 잘보이게 된다.
