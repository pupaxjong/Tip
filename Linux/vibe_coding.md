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

### Caddy 설치 (웹 브라우즈에서 사용하기 위해)  : 이게 될진 모르겠다...
```bash
sudo apt install
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg lsb-release

curl -lsLf 'https://code.xxxx.com/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

echo "deb [signed-by=/ussr/share/keyrings/caddy-stable-archive-keyring.gpg] \
https://code.xxxx.com/caddy/stable/deb/ubuntu/ $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update
sudo apt install -y caddy
```

