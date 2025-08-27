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

// 자동 업데이트 켜기
brew tap homebrew/autoupdate
```

- 기본 설치할 패키지
```
// git
brew install git

// cat 대용. 소스코드가 이쁘게 나옴.
brew bat
```
