# GIT
### 터미널에서 git 사용
- [참고](https://jeeqong.tistory.com/81)   
- [참고 2](https://kfdd6630.tistory.com/entry/Git-Github-ssh-%EC%97%B0%EA%B2%B0-%EC%B4%9D-%EC%A0%95%EB%A6%AC)   

```sh
# 사용자 설정 : 로컬저장소를 사용하든, 원격저장소를 사용하든 미리 세팅해놓은 사용자 이름과 이메일로 커밋이 될 것입니다.
git config --global user.name "사용자이름"
git config --global user.email "이메일"


# Initialized empty Git repository in /Users/xxxx/Documents/example/.git/
git init

# 생성한 SSH 키를 SSH 에이전트에 추가합니다.
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 만약 "Could not open a connection to your authentication agent." 오류가 발생한다면, SSH 에이전트를 다시 시작
ssh-agent -k
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 등록됐는지 확인하기
ssh-add -l

# 연결 테스트
ssh -T git@github.com
```

### ✅ 원인 3: 리모트 URL이 SSH 형식인데 HTTPS를 써야 하는 경우
- 만약 SSH 설정이 귀찮다면, HTTPS 방식으로 리모트 URL을 변경할 수도 있습니다:
- REPO_NAME 부분은 본인의 실제 리포지토리 이름으로 바꿔주세요.
```sh
git remote set-url origin https://github.com/GIT_ID/REPO_NAME.git
```

## 퍼미션 에러날때
- [참고](https://realzzu.tistory.com/115)   

```sh
GIT_ID@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

- 원격 저장소 해제하고 다시 설정해야 한다.
```sh
# 원격 저장소 해제
git remote remove origin

# 원격 저장소 다시 연결하기
git remote add origin https://github.com/깃허브아이디/깃허브저장소명.git

# 현재 로컬 저장소의 원격 상태를 확인하려면
git remote -v

# 로컬 저장소의 원격 저장소 지정
git push --set-upstream origin main
```
<br>   

## 맥용 소스트리에서 비공개 서브 모듈 pull 되지 않을때 터미널에서   

```sh
git config --global credential.helper osxkeychain
```
