# 발급받은 도메인이 있고, nginx 를 사용중일때

# nginx 를 사용시

- 설치
```sh
sudo apt update
sudo apt install nginx -y

# 상태 확인
sudo systemctl status nginx
```

---   

<br>   


# cloudflare 에서 관리할 경우
- 환경설정 파일만 만들면 될듯..
```bash
sudo vi /etc/nginx/sites-available/exsample
```
```text
server {
    listen 80;
    server_name exsample.xxx.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name exsample.xxx.com;

    ssl_certificate /etc/letsencrypt/live/exsample.xxx.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/exsample.xxx.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:port_num;
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

```bash
sudo ln -s /etc/nginx/sites-available/exsample.xxx.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

----    


<br><br>   

# nginx 에서 인증서 발급시
## 1. 와일드 인증서 발급 : *.xxx.com 
### 터미널 2개를 열어서 작업을 해야 한다.
```bash
sudo certbot -d "*.xxx.com" -d "xxx.com" --manual --preferred-challenges dns certonly
```
- 이미 인증서가 있다면
```text
# 선택하는게 나오는데 e 는 기존거에 와일드 인증서를 추가하는것임.
(E)xpand/(C)ancel: e
```

### 진행되다가 아래처럼 나오면.. enter 치치 말고 가입한 호스팅 페이지의 dns 에 TXT 레코드 추가
- 아래 값을 txt 레코드의 값에다가 넣어야 함.
```text
Please deploy a DNS TXT record under the name:

_acme-challenge.xxx.com.

with the following value:

ckdkeiffsdfsdfsdfsdfdfsdfsdfsdfdsf-A_w

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.xxx.com.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

### TXT 레코드 추가하기
```text
유형(타입) : TXT
호스트이름 : _acme-challenge
값 : ckdkeiffsdfsdfsdfsdfdfsdfsdfsdfdsf-A_w
```
- 등록 완료후 다른터미널에서 배포가 됐는지 확인을 해야 한다.
- 20 ~ 30 분 기다려야 하는듯...
```bash
nslookup code.xxx.com
```   

```text
** server can't find code.xxxx.com: NXDOMAIN

----
NXDOMAIN 가 나오면 안됨.. 등록한 값(ckdkeiffsdfsdfsdfsdfdfsdfsdfsdfdsf-A_w)과  비교하여 같은지 확인.
```

- 환경설정
```bash
sudo vi /etc/nginx/sites-available/xxx.com
```
```text
server {
    listen 80;
    server_name xxx.com *.xxx.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name xxx.com *.xxx.com;

    ssl_certificate     /etc/letsencrypt/live/xxx.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/xxx.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/html;
    index index.html;
}
```

```bash
sudo ln -s /etc/nginx/sites-available/xxx.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 인증서는 90일 유효 → 자동 갱신 설정됨
```bash
sudo certbot renew --dry-run
```

-----    

<br><br>   
<br><br>   

# 2. nginx : 개별인증서 사용시 
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
