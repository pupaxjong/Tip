# 바이브 코딩을 위해 node js 설치하기
```bash
sudo apt install curl ca-certificates gnupg -y
```

- node js 설치
```bash
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
```

```bash
sudo apt install -y nodejs
```

### claude-code 설치
```bash
sudo npm install -g @anthropic-ai/claude-code
```
- 실행
```bash
claude
```

### google gemini cli 설치
```bash
sudo npm install -g @google/gemini-cli
```
- 실행
```bash
gemini
```

