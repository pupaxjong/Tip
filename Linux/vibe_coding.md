# 바이브 코딩을 위해 node js 설치하기
-[참고 영상](https://www.youtube.com/watch?v=4ydoXtc6U1o&t=1092s)    

```bash
sudo apt install curl ca-certificates gnupg -y
```

## node js 설치
```bash
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
```

```bash
sudo apt install -y nodejs
```

## claude-code 설치
```bash
sudo npm install -g @anthropic-ai/claude-code
```
- 실행
```bash
claude
```

## google gemini cli 설치
```bash
sudo npm install -g @google/gemini-cli
```
- 실행
```bash
gemini
```

## 무료 dns 발급받기
```text
desec.io
가입후
Register a new domain under ....  를 체크하고
사용할 도메인을 입력한다.
Tell me about 는 체크 해제한다.

이멜로 로그인 완료한다.

발급된 도메인으로 들어가서
레코드를 추가한다.
유형 : A   그대로 둔다.
호스티 이름 : n8n
ip : 본인 공인 아이피 사용

등록한다.. code 도 등록
```


## vscode 설치
```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

- code-server 실행
```bash
sudo systemctl enable --now code-server@$USER
```
- 환경설정하기
```bash
cat > ~/.config/code-server/config.yaml
```
- 아래 입력..패스워드는 수정할것
```text
bind-addr: 127.0.0.1:10000
auth: password
password: xxxxxxxxxx
cert: false

# ctrl+c 종료하면 수정이됨.
```

- 상태 확인
```bash
sudo systemctl status code-server@계정 -l
```
- 재시작하기
```bash
sudo systemctl restart code-server@계정
```

### Caddy 설치 (웹 브라우즈에서 사용하기 위해)  : 나는 도메인이 있고, ngnix 를 사용하고 있어서 이건 건너띔.. 아래 ngnix 부분에서 ....
- 아래 한번에 복사해서 실행할것
```bash
sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg lsb-release

curl -lsLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

echo "deb [signed-by=/ussr/share/keyrings/caddy-stable-archive-keyring.gpg] \
https://dl.cloudsmith.io/caddy/stable/deb/ubuntu/ $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update
sudo apt install -y caddy
```

- 아래는 하나씩 실행
```bash
sudo systemctl enable --now caady
sudo systemctl status caddy
caddy verion
```

- 환경 설정
```bash
sudo vi /etc/caddy/Caddyfile
```
아래 복사 붙여넣기
```text
게정-code.duckdns.org {
  reverse_proxy localhost:10000
}

게정-n8n.duckdns.org {
  reverse_proxy localhost:5678
}
```
- Caddy 재시작
```bash
sudo systemctl restart caddy
sudo systemctl status caddy
```

- [vscode 접속하기](게정-code.duckdns.org)

----    

<br><br>    

# ngnix 를 사용시
## dns 사이트에서 네임서버 등록 : 등록후 20~30분 정도 기다려야함.
- 유형(타입) : CNAME
- 호스트 이름 : code
- 값 : xxxx.com

### 확인
```bash
dig code.xxx.com
```
또는:
```bash
nslookup code.xxx.com
```
했을때 ip 나오면 성공. 안나오면 더 기다려야함.

```text
** server can't find code.xxxx.com: NXDOMAIN

----
NXDOMAIN 가 나오면 안됨.. 아이피가 나와야 함.
```


## 파일 생성
```bash
sudo vi /etc/nginx/sites-available/code-server
```

## 설정하기 : 인증서 발급이 안되었기 떼문에.. 기본 80 에 대해서만 먼저 입력한다.
```text
server {
    listen 80;
    server_name code.xxx.com;

    location / {
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 심볼릭 링크 생성 후 재시작.
```bash
sudo ln -s /etc/nginx/sites-available/code-server /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 인증서 발급

- Let's Encrypt SSL 인증서 발급하기
설치가 안되었다면 설치하기
```bash
sudo apt install certbot python3-certbot-nginx -y
```

- 인증서 발급 : 실패하면.. 아직 네임서버에 ip 가 등록이 안되었을수 있으므로 기다리기...
- nslookup code.xxx.com 로 확인하기 : NXDOMAIN 가 아닌 아이피가 나올때까지 확인.
```bash
sudo certbot certonly --nginx -d code.xxxx.com
```

## ssl 설정하기
```bash
sudo vi /etc/nginx/sites-available/code-server
```

```text
server {
    listen 80;
    server_name code.xxx.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name code.xxx.com;

    ssl_certificate /etc/letsencrypt/live/code.xxx.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/code.xxx.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}


## nginx 설정 테스트 및 재시작
```sh
sudo nginx -t
sudo systemctl reload nginx
```

## 자동 갱신 설정 확인 : 한번이라도 했었다면 안해도 됨.
- 인증서는 90일 유효 → 자동 갱신 설정됨
```bash
sudo certbot renew --dry-run
```





