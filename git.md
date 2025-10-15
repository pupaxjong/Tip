# 🧠 Git 터미널 사용법 완전 정리 (기본부터 고급까지)

Git을 터미널에서 사용할 때 꼭 알아야 할 명령어들을 한눈에 보기 좋게 정리했습니다.  
기본 사용법부터 브랜치 관리, 커밋 되돌리기, 서브모듈, 히스토리 탐색, `.gitignore`, `merge vs rebase`, GitHub Actions, CI/CD, Git Flow 전략, GitHub Pages, 고급 기능까지 모두 포함되어 있어요.

---

## ✅ 기본 명령어

```bash
git init                          # 현재 디렉토리를 Git 저장소로 초기화
git clone <URL>                  # 원격 저장소를 로컬로 복제
git status                       # 현재 작업 상태 확인
git add <파일명>                 # 변경된 파일을 스테이지에 추가
git commit -m "메시지"           # 커밋 생성
git log                          # 커밋 히스토리 확인
git diff                         # 변경된 내용 비교
git push                         # 로컬 변경사항을 원격 저장소에 반영
git pull                         # 원격 변경사항을 가져와 병합
git fetch                        # 원격 변경사항을 가져오기만 함
```

---

## 🔄 커밋 되돌리기

```bash
git restore <파일명>             # 변경사항 되돌리기 (작업 디렉토리 기준)
git reset --soft HEAD~1         # 마지막 커밋 되돌리기 (스테이지는 유지)
git reset --hard HEAD~1         # 마지막 커밋 완전히 삭제
git revert <커밋해시>           # 특정 커밋을 되돌리는 새 커밋 생성
```

---

## 🌿 브랜치 관리

```bash
git branch                       # 브랜치 목록 확인
git branch <브랜치명>            # 새 브랜치 생성
git checkout <브랜치명>          # 브랜치 이동
git switch <브랜치명>            # 브랜치 이동 (추천 방식)
git branch -d <브랜치명>         # 병합된 브랜치 삭제
git branch -D <브랜치명>         # 병합되지 않아도 강제 삭제
git branch -m <이전> <새이름>    # 로컬 브랜치 이름 변경
git push origin <새이름>         # 새 이름으로 원격 푸시
git push origin --delete <이전>  # 원격 브랜치 삭제
git push --set-upstream origin <브랜치명>  # 원격 브랜치 연결
```

---

## 📦 서브모듈 관리

```bash
git submodule add <URL> <경로>          # 서브모듈 추가
git submodule update --init --recursive # 서브모듈 초기화 및 다운로드
git submodule update --remote           # 서브모듈 최신 커밋으로 갱신

# 서브모듈 제거
git config -f .gitmodules --remove-section submodule.<경로>
git config --remove-section submodule.<경로>
git rm --cached <경로>
rm -rf <경로>
rm -rf .git/modules/<경로>
```

---

## 🕰️ 히스토리 탐색 및 이전 버전으로 돌아가기

```bash
git log                                 # 커밋 히스토리 확인
git show <커밋해시>                     # 특정 커밋의 상세 내용 보기
git checkout <커밋해시>                 # 해당 커밋 상태로 이동 (Detached HEAD)
git switch -c <새브랜치명>              # 해당 커밋에서 새 브랜치 생성
git reflog                              # HEAD 이동 히스토리 확인
git reset --hard HEAD@{n}               # 이전 상태로 되돌리기 (reflog 기반)
```

---

## 📌 기타 유용한 명령어

```bash
git stash                               # 변경사항 임시 저장
git stash pop                           # 저장한 변경사항 복원
git remote -v                           # 연결된 원격 저장소 확인
git config --global user.name "이름"    # 사용자 이름 설정
git config --global user.email "이메일" # 사용자 이메일 설정
git tag <태그명>                        # 태그 생성
git tag -d <태그명>                     # 태그 삭제
git push origin <태그명>                # 태그 푸시
git push origin --delete <태그명>       # 원격 태그 삭제
```

---

## 📁 .gitignore 설정

`.gitignore` 파일은 Git이 추적하지 않을 파일/폴더를 지정하는 설정 파일입니다.

### 예시:

```
# 빌드 결과물
/dist
/build

# 로그 파일
*.log

# OS/IDE 관련
.DS_Store
node_modules/
.vscode/
.env
```

> `.gitignore` 파일은 프로젝트 루트에 위치하며, 커밋 전에 설정해야 효과가 있습니다.

---

## 🔀 merge vs rebase 차이점

| 항목         | `git merge`                                  | `git rebase`                                 |
|--------------|-----------------------------------------------|-----------------------------------------------|
| 목적         | 브랜치를 병합하여 새로운 커밋 생성            | 커밋을 다른 브랜치 위로 재배치                |
| 커밋 기록    | 병합 커밋(`merge commit`)이 생김              | 커밋 히스토리가 깔끔하게 이어짐               |
| 충돌 처리    | 병합 시점에서 충돌 발생                        | 재배치 중 각 커밋마다 충돌 발생 가능          |
| 협업 시기    | **공용 브랜치 병합 시 사용** (ex. main)       | **개인 브랜치 정리 시 사용** (push 전)        |

### 사용 예시

```bash
# merge
git checkout main
git merge feature/login

# rebase
git checkout feature/login
git rebase main
```

---

## ⚙️ GitHub Actions & CI/CD 연동

GitHub Actions는 GitHub 저장소에 자동화된 워크플로우(CI/CD)를 설정할 수 있는 기능입니다.

### 기본 구조

`.github/workflows/ci.yml`

```yaml
name: CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
```

> 이 워크플로우는 main 브랜치에 push 또는 PR이 발생할 때 자동으로 테스트를 실행합니다.

---

## 🧭 Git Flow 전략

Git Flow는 협업과 릴리즈 관리를 위한 브랜치 전략입니다.

### 주요 브랜치

- `main`: 배포용 안정 버전
- `develop`: 개발 중인 통합 브랜치
- `feature/*`: 기능 개발 브랜치
- `release/*`: 릴리즈 준비 브랜치
- `hotfix/*`: 긴급 수정 브랜치

### 흐름 예시

```bash
# 기능 개발 시작
git checkout -b feature/login develop

# 기능 완료 후 develop에 병합
git checkout develop
git merge feature/login

# 릴리즈 준비
git checkout -b release/v1.0 develop

# 릴리즈 완료 후 main에 병합
git checkout main
git merge release/v1.0
git tag v1.0

# develop에도 병합
git checkout develop
git merge release/v1.0

# 긴급 수정
git checkout -b hotfix/urgent-fix main
```

> Git Flow는 `git-flow` CLI 도구로도 관리 가능: `brew install git-flow` 또는 `apt install git-flow`

---

## 🌐 GitHub Pages 배포

정적 웹사이트를 GitHub 저장소에서 바로 배포할 수 있습니다.

### 기본 방식

1. 저장소 루트 또는 `docs/` 폴더에 `index.html` 파일 생성
2. GitHub 저장소 → Settings → Pages → Source 선택
   - `main` 브랜치의 `/docs` 또는 루트 선택
3. 저장 후 `https://사용자명.github.io/저장소명` 주소로 접속

### React/Vue/Svelte 프로젝트 배포 예시

```bash
npm run build
git add dist
git commit -m "배포용 빌드 추가"
git subtree push --prefix dist origin gh-pages
```

> 또는 `gh-pages` 브랜치를 따로 만들어서 `npm run deploy`로 자동화 가능

---

## 🧩 추가로 알아두면 좋은 고급 기능

```bash
git cherry-pick <커밋해시>       # 특정 커밋만 선택적으로 적용
git bisect                       # 버그 발생 시점 찾기 (이진 탐색)
git blame <파일>                # 각 줄의 마지막 수정자 확인
git clean -fd                   # 추적되지 않은 파일/폴더 삭제
git archive --format=zip HEAD > latest.zip  # 특정 커밋을 zip으로 내보내기
```

---

## 📦 Git LFS (Large File Storage)

대용량 파일을 Git으로 관리할 때 사용하는 확장 기능입니다.

```bash
git lfs install
git lfs track "*.psd"
git add .gitattributes
git add design.psd
git commit -m "Add large file with LFS"
```

> `.gitattributes`에 추적 패턴이 기록되며, GitHub에서 대용량 파일을 효율적으로 관리할 수 있습니다.

---

## 🧠 Monorepo 전략

하나의 저장소에서 여러 프로젝트를 관리하는 방식입니다.

### 폴더 구조 예시

```
/apps
  /web
  /mobile
/packages
  /ui
  /utils
```

### 도구 추천

- `Nx`, `Turborepo`, `Lerna` 등으로 빌드/테스트/배포 자동화
- `pnpm`의 workspace 기능으로 의존성 관리

---

## 📚 Git 문서화 팁

- `README.md`: 프로젝트 소개, 설치 방법, 사용법
- `CONTRIBUTING.md`: 기여 가이드
- `CHANGELOG.md`: 버전별 변경사항 기록
- `LICENSE`: 라이선스 명시

---

