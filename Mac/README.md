[1. 맥용 소스트리에서 비공개 서브 모듈 pull 되지 않을때](git.md)   

## sshpass 설치
```
> brew install hudochenkov/sshpass/sshpass
iTerm
   Command : Login Shell : sshpass -p 'password' ssh -p 'port num' 계정@ip    : port num 22 이면 생략 가능
```

# HomeBrew 설치하기
- [가장 좋은곳](https://blog.te6.in/post/macos-first-things-to-do-homebrew)
- [참고 1](https://m.blog.naver.com/redwave102/223143368267)   
- [참고 2](https://m.blog.naver.com/wool613/221677114237)
- [참고 3 - 에러 대응도 있음.](https://black-whisker.tistory.com/entry/%EB%A7%A5%EB%B6%81-%ED%95%84%EC%88%98-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8-Homebrew-%EC%84%A4%EC%B9%98-%EB%B0%A9%EB%B2%95%EA%B3%BC-%ED%95%84%EC%88%98-%ED%8C%A8%ED%82%A4%EC%A7%80-%EC%B6%94%EC%B2%9C-2025-%EC%B5%9C%EC%8B%A0)   
  
- 삭제
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

- 설치
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

// 설치 확인용
brew docter

// 필요하면.. 자동 업데이트 켜기
brew tap homebrew/autoupdate
```

- 기본 설치할 패키지
```
brew install iterm2

// git
brew install git

// cat 대용. 소스코드가 이쁘게 나옴.
brew bat
```

<br>    


# 파이썬 설치
# 🐍 macOS에서 pyenv로 Python 관리하기

Python 버전을 유연하게 설치하고 관리하기 위해 사용하는 `pyenv`의 설치 및 설정 방법을 정리합니다.

---

## 1. pyenv 설치

```bash
brew install pyenv
```

**설명:**  
Homebrew를 통해 `pyenv`를 설치합니다.  
`pyenv`는 여러 버전의 Python을 시스템에 영향을 주지 않고 독립적으로 설치하고 관리할 수 있게 해주는 도구입니다.

---

## 2. 셸 설정에 pyenv 초기화 추가

**설명:**  
터미널이 `pyenv`를 인식하도록 환경 설정 파일에 초기화 코드를 추가합니다.

### zsh 사용자 (`~/.zshrc`)

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

### bash 사용자 (`~/.bash_profile`)

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init --path)"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
```

**적용 방법:**  
설정 후 터미널을 재시작하거나 아래 명령어를 실행합니다:

```bash
source ~/.zshrc        # zsh 사용자
source ~/.bash_profile # bash 사용자
```

---

## 3. 원하는 Python 버전 설치

```bash
pyenv install 3.12.2
```

**설명:**  
`pyenv`를 사용하여 Python 3.12.2 버전을 설치합니다.  
설치된 버전은 `~/.pyenv/versions/3.12.2` 경로에 저장되며, macOS 기본 Python과는 별도로 독립적으로 작동합니다.

---

## 4. 기본 Python 버전 설정

```bash
pyenv global 3.12.2
```

**설명:**  
기본적으로 사용할 Python 버전을 3.12.2로 설정합니다.  
이후 터미널에서 `python`, `python3`, `pip` 명령어를 입력하면 pyenv가 지정한 3.12.2 버전을 참조하게 됩니다.  
설정은 `~/.pyenv/version` 파일에 저장됩니다.

---

## ✅ 확인 명령어

```bash
python --version
python3 --version
which python3
```

**결과:**  
출력 결과가 `Python 3.12.2`이고 경로가 `~/.pyenv/...`이면 설정 성공입니다.
