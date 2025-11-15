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
### code-server 실행
```bash
sudo systemctl enable --now code-server@$USER
```

### 환경 설정하기

#### 구글 인증 모드
- 외부에서 접속할려면 구글 OAuth 인증 추가.
  - 구글콘솔 -> 프로젝트 -> api 및 서비스 -> 사용자 인증
    - 사용자 인증 추가
      - 웹 어플리케인션
      - 앱이름 : code.xxxx.com
      - redirect-uri: https://code.xxx.com/oauth/callback
    - client-id, client-secret 카피후 적용하기

```bash
vi ~/.config/code-server/config.yaml
```
- 키들 적용하기
```text
bind-addr: 0.0.0.0:8080
auth: oauth
oauth2:
  provider: google
  client-id: <YOUR_GOOGLE_CLIENT_ID>
  client-secret: <YOUR_GOOGLE_CLIENT_SECRET>
  redirect-uri: https://code.jwent.pe.kr/oauth/callback
cert: false
```

---   

<br>   


#### 패스워드 모드. 

```bash
vi ~/.config/code-server/config.yaml
```
- 아래 입력..패스워드는 수정할것
```text
bind-addr: 127.0.0.1:10000
auth: password
password: xxxxxxxxxx
cert: false
```

---   

### 상태 확인
```bash
sudo systemctl status code-server@계정 -l
```
### 재시작하기
```bash
sudo systemctl restart code-server@계정
```

---   

<br><br>    


### Caddy 설치 (웹 브라우즈에서 사용하기 위해)  : 나는 도메인이 있고, nginx 를 사용하고 있어서 이건 건너띔.. 아래 nginx 부분에서 ....
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

<br>    

# [nginx 를 사용시](nginx.md)   

