# Cloudflare 에서 DNS와 네임 서버 관리하기
- ssl 인증을 해주니깐 편한다..
- [홈페이지 대시보드 바로 가기](https://dash.cloudflare.com/)
- 계정을 생성.

## 상단에 계정을 클릭하면 대시보드로 들어와진다.
- 도메인이 없어면 구매할수 있지만...다른 곳에서 구매해도 된다.
- 무료 도메인을 사용해도 될거 같다..
- 도메인 온보딩 클릭하여 구해만 도메인을 등록한다.
- DNS 에서 레코드를 등록한다.

---   

<br><br>   

# Cloudflare zero trust
- code-server 를 리눅스에 설치
  - code-server 는 패스워드 인증, none 만 지원을 해서.. 구글,github등 외부 인증을 추가할때 사용.
- 무료 플랜가입을 한다. : 50명까지 사용가능.

## 1️⃣ code-server config.yaml  
경로: ~/.config/code-server/config.yaml

```text
bind-addr: 127.0.0.1:8080    # 외부에서 직접 접근 금지
auth: none                   # Cloudflare Access로 인증 처리
cert: false                  # Tunnel이 HTTPS 처리
```

## 2️⃣ cloudflared 설치 & Tunnel 생성

### 설치
```bash
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
sudo dpkg -i cloudflared.deb
```

### 로그인 (Cloudflare 계정)
```bash
cloudflared login
```

### Tunnel 생성
```bash
cloudflared tunnel create code-server
```

➡️ 생성 후 credentials 파일 경로 확인 (~/.cloudflared/<Tunnel ID>.json)

## 3️⃣ cloudflared config.yml 작성  
경로: /etc/cloudflared/config.yml  

### root 권한으로 해야 하기때문에.. 일단 유저 홈에서 만든후 복사한다.  
### 홈 디렉토리에서 작성
```bash
vi ~/config.yml
```
```bash
tunnel: code-server
credentials-file: /root/.cloudflared/<Tunnel ID>.json

ingress:
  - hostname: code.xxx.com
    service: http://127.0.0.1:10000
  - service: http_status:404
```

### 완료 후 root 권한으로 이동
```bahs
sudo mkdir -p /etc/cloudflared
sudo mv ~/config.yml /etc/cloudflared/config.yml
sudo chown root:root /etc/cloudflared/config.yml
sudo chmod 600 /etc/cloudflared/config.yml
```

hostname : 브라우저에서 접속할 도메인  
service : code-server가 바인딩된 localhost:8080  
나머지 트래픽은 404 처리  

## 4️⃣ cloudflared systemd 서비스
```bahs
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared
```
✅ 정상 실행 확인 → Active: active (running)

## 5️⃣ Cloudflare Access 설정  

### 인증 추가
- Dashboard → Zero Trust → 설정 → 인증 → 로그인 방법에서 새항목 추가
  - 구글선택시
    - 앱 ID : 구글 앱 클라이언트 ID 설정
    - 클라이언트 암호 : 스크릿 키
    - 코드 교환용 증명 키(PKCE) ON
    - 나머지는 안해도 되늗듯..
    - 저장후 테스트 했을때 성공하면 끝.
- 다른것들도 비슷함.

### Dashboard → Zero Trust → Access → 정책
- 기본 정보
  - 정책 이름 : ...
  - 작업 : Allow (기본값 사용)
  - 세션기간 : 응용프로그램 세션과 시간 동일 ( 기본 사용 ).
---   
- 규칙 추가 : 아래 처럼 하면 나만 접속이 가능하다고 하느데....  Emails 를 추가하지 않으면 login methods 때문에 대상 로그인한 모든 유저가 접속을 하게 된다.
  - 포함
    - 선택기 : Login Methods
    - 값 : Goolge, github 추가하고 싶은거.
  - 필요
    - 선택기 : Emails
    - 값 : 내 이메일
- 정책 테스트 해서 성공하면 끝.

---
## 응용 프로그램 추가
- Dashboard → Zero Trust → Access → Applications → Add Application  
- Type → Self-hosted(자체 호스팅)
---   
### 응용프로그램 추가 창.
- 응용 프로그램 이름 : code-server
- 세션 기간 : 24 시간 기본사용.
---   
- + 개인 호스트 이름 추가 클릭
  - 호스트 이름 : code.xxx.com
  - 포트 번호 : 443 (기본포트) - 다른걸로 사용이 가능할거 같은데.....
---   
- Access 정책 설정 : 기존 정책 선택. 정책 추가한게 없다면 새정책 생성.
  생성한 정책 선택.
---   
- 로그인 방법 : 위에서 인증 추가하면 추가한거 리스트에 나온다.
  - 사용가능한 모든 ID 공급자 수락 : 체크 해제
  - 원하는 로그인 방법 선택. 

- 나머지는 기본으로 설정.
- 저장. 
---   

## 6️⃣ 접속 테스트  
브라우저에서: https://code.xxx.com  
➡️ Google 로그인 화면 → 인증 성공 → code-server 페이지 접근 가능  
➡️ n8n은 기존 nginx 443 그대로 접속 가능  

## ✅ 요약  
- n8n: 기존 nginx 443 사용 → 그대로 HTTPS  
- code-server: 127.0.0.1:8080 + Cloudflare Tunnel → Google 로그인 필수  
- 외부에서 code-server 직접 접근 불가 → 안전  
- Cloudflare Access 적용 → 인증 필수  
