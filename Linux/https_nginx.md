# HTTPS 인증서 설정

## ✅ 1. 사전 준비
- n8n 컨테이너가 내부 포트 5678에서 실행 중
- 도메인 예시: n8n.example.com
- DNS가 해당 서버 IP를 가리키고 있어야 함
- 포트 80, 443이 방화벽에서 열려 있어야 함

## ✅ 2. Nginx 설치
```bash
sudo apt update
sudo apt install nginx
```

✅ 3. Nginx 설정 파일 생성
```bash
sudo vi /etc/nginx/sites-available/n8n
```

- 내용 수정
```text
server {
    listen 80;
    server_name n8n.example.com;

    location / {
        proxy_pass http://localhost:5678;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- 설정하기
```bash
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## ✅ 4. HTTPS 인증서 발급 (Let's Encrypt)
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d n8n.example.com
```
→ 인증서 발급 후 자동으로 HTTPS 설정됨

## ✅ 5. n8n 환경 변수 설정
컨테이너 실행 시 아래 환경 변수 추가:
```bash
-e N8N_HOST=n8n.example.com \
-e N8N_PORT=5678 \
-e N8N_PROTOCOL=https \
-e N8N_SECURE_COOKIE=true
```


