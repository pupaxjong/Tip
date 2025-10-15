# 🧱 Git 서브모듈 완전 정리

Git 프로젝트에서 서브모듈을 사용하는 모든 핵심 명령어를 한눈에 정리했습니다.

---

## ✅ 서브모듈 다운로드 (초기화 + 업데이트)

```bash
git submodule update --init --recursive
```

- `.gitmodules`에 정의된 서브모듈을 초기화하고 다운로드
- 서브모듈 안에 또 서브모듈이 있을 경우까지 모두 처리

---

## ➕ 서브모듈 추가

```bash
git submodule add <저장소 URL> <경로>
```

예시:

```bash
git submodule add https://github.com/example/lib tools/lib
```

- `<저장소 URL>`: 서브모듈로 추가할 Git 저장소 주소
- `<경로>`: 현재 프로젝트 내에서 서브모듈이 위치할 디렉토리

---

## ❌ 서브모듈 제거

```bash
# 1. .gitmodules에서 제거
git config -f .gitmodules --remove-section submodule.<경로>

# 2. .git/config에서 제거
git config --remove-section submodule.<경로>

# 3. Git index에서 제거
git rm --cached <경로>

# 4. 실제 디렉토리 삭제
rm -rf <경로>
```

> `<경로>`는 서브모듈이 위치한 폴더 이름

---

## 🔄 서브모듈 갱신 (최신 커밋으로)

```bash
git submodule update --remote
```

- 서브모듈의 원격 저장소에서 최신 커밋을 가져옴
- `.gitmodules`에 설정된 브랜치 기준으로 업데이트됨

---

## 🧹 서브모듈 전체 초기화 (클린 상태로)

```bash
git submodule deinit -f .
git rm -f <경로>
rm -rf .git/modules/<경로>
```

---

## 📦 서브모듈 포함해서 클론하기

```bash
git clone --recurse-submodules <저장소 URL>
```

> 처음부터 서브모듈까지 포함해서 클론하려면 이 옵션을 사용

---
