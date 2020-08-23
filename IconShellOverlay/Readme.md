``` test

git, svn 같은것들 아이콘이 오버레이 되지 않을때 레지스트리를 수정한다.

https://github.com/pupaxjong/etc/issues/1#issue-684137669

run regedit

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers

Tortoise1Normal 같은것들 스페이스 공간을 많이 줘서 제일 안쪽에 가도록 하면 된다. 그런후에

IconShellOverlay.bat 실행하면 탐색기가 리로드 되어서 잘보이게 된다.
