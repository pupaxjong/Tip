# Docker 에 coder-server 설치

## code-server.sh 사용.
```bash
사용 가능한 명령어.
--help                 : 사용법 출력.
start / stop / restart : 컨테이너 시작, 중지에만 관여
up / down / recreate   : 컨터이너 삭제, 생성 에 관여..

--------------------

./code-server.sh up <cli / compose>
- cli : docker -d run ....
- compose : docker-compose.yml 사용.
```

## docker-compose.yml

```bash
version: '3.8'

services:
  code-server:
    image: codercom/code-server:latest
    container_name: code-server
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - code-server-data:/home/coder/project
    environment:
      - PASSWORD=your-password  # 또는 auth: none 설정 시 제거 가능

volumes:
  code-server-data:
```
- 컨테이너 내부에서 home/coder/.config/code-server/config.yaml 에 자동 생성됨.
- 패스워드 기반으로 생성이 됨.
```text
bind-addr: 0.0.0.0:8080
auth: password
password: your_password_here
cert: false
```
---   

## 사용법.
```bash
# 1️⃣ docker-compose.yml 파일 생성
vi docker-compose.yml  # 또는 nano, vim 등 편집기 사용

# 2️⃣ 컨테이너 실행
docker compose up -d

# 3️⃣ 상태 확인
docker compose ps
```
