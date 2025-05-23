# Docker 실습 연습문제

## 1. 기본 컨테이너 실행
nginx 웹 서버 컨테이너를 실행하세요.
- 컨테이너명: web-server
- 포트: 호스트의 8080 -> 컨테이너의 80
- 백그라운드 실행

정답:
```bash
docker container run -d --name web-server -p 8080:80 nginx
```

## 2. MySQL 컨테이너 실행
MySQL 데이터베이스 컨테이너를 실행하세요.
- 컨테이너명: mysql-db
- root 비밀번호: 1234
- mysql 버전: 8.0
- 포트: 호스트의 3306 -> 컨테이너의 3306
- 환경변수 설정: MYSQL_DATABASE=mydb, TZ=Asia/Seoul
- 백그라운드 실행

정답:
```bash
$ docker container run \
> --detach \
> --name mysql-db \
> -e MYSQL_ROOT_PASSWORD=1234 \
> -e MYSQL_DATABASE=mydb \
> -e TZ=Asia/Seoul \
> --publish 3306:3306 \
> mysql:8.0
```

- mysql에 접속
```bash
mysql --host=127.0.0.1 --port=3306 --user=root --password=1234
```

- 현재 TZ 조회 명령어 확인 
```bash
SELECT @@system_time_zone;
+--------------------+
| @@system_time_zone |
+--------------------+
| KST                |
+--------------------+
```

## 3. PostgreSQL 데이터베이스 컨테이너 실행 
- 컨테이너명: postgres-db
- 사용자 : myuser
- 사용자 비밀번호: 1234
- postgresql 버전: 15.0
- 포트: 호스트의 5433 -> 컨테이너의 5432
- 환경변수 설정: POSTGRES_DB=mydb, TZ=Asia/Seoul
- 백그라운드 실행

정답:
```bash
docker container run -d --name postgres-db \
-e POSTGRES_USER=myuser \
-e POSTGRES_PASSWORD=1234 \
-e POSTGRES_DB=mydb \
-e TZ=Asia/Seoul \
-p 5433:5432 \
postgres:15.0
```

- postgres에 접속
```bash
psql --host=127.0.0.1 --port=5433 --username=myuser --dbname=mydb
```

- 현재 TZ 조회 명령어 확인
```bash
mydb=# SHOW TIMEZONE;
  TimeZone  
------------
 Asia/Seoul
(1 row)
```

## 4. 도커 컨테이너 종료, 전체 삭제
- 실행중인 도커 컨테이너 모두 중지 

정답:
```bash
docker container stop $(docker container ls -q)
```

## 5. 등록된 모든 도커 이미지 삭제
정답:
```bash
docker image rm -f $(docker images -q)
```

## 6. Python Flask 개발 환경 이미지 만들기 
- Flask 웹 애플리케이션을 실행할 수 있는 최소한의 설정 포함 
    + app.py: Flask 애플리케이션의 메인 파일
    + requirements.txt: 필요한 패키지 목록
    + templates/index.html: 웹 페이지의 레이아웃을 정의하는 HTML 파일
    + Dockerfile: 이미지 빌드 설정 파일
- 주어진 파일을 기반으로 Dockerfile 작성 

```bash
qna06/
├── app.py
├── requirements.txt
├── Dockerfile
└── templates/
    └── index.html
```

- Dockerfile을 통해서 이미지 빌드하기 
- 빌드할 때 태그 버전은 지정하지 않는다.
- 이미지명 : flask-app

정답:
```bash
docker image build --tag flask-app .
```

- 이미지 확인
```bash
docker image ls
```

- Docker 컨테이너 실행
   + 컨테이너명: flask-app-container
   + 백그라운드 실행
   + 종료 시 자동 삭제
   + 127.0.0.1:5000 접속 

정답:
```bash
docker container run -d -it --name flask-app-container --rm -p 5000:5000 flask-app
```

- 컨테이너 확인
```bash
docker container ls
```

- 컨테이너 종료 
```bash
docker container stop flask-app-container
```

## 7. 이미지 태그 지정
- 로컬에 있는 이미지에 새로운 태그를 지정하고 Docker Hub에 푸시하세요.
- 기존 이미지 : flask-app
- 새로운 이미지명 및 태그 yourname/myflask-app:1.0.0
- Docker Hub에 Push

정답:
```bash
docker tag flask-app jhjung430/myflask-app:1.0.0
docker push jhjung430/myflask-app:1.0.0
```

## 8. Volume Mount 
- qna08 디렉터리 생성 
- 요구사항: 
1. 볼륨 생성
   - 볼륨명: mysql_logs
   - 용도: MySQL 로그 저장
정답:
```bash
docker volume create mysql_logs
```

2. 쿼리 로그 활성화 설정 파일 생성
- 파일명: my.cnf
- 내용: 쿼리 로그 활성화

정답:
```plaintext
[mysqld]
general_log=1
general_log_file=/var/log/mysql/query.log
```

3. Dockerfile 작성 (qna08/Dockerfile)
   - 베이스 이미지: mysql:8.0
   - MySQL 설정 파일 추가 (쿼리 로그 활성화)

정답:
```plaintext
FROM mysql:8.0

COPY my.cnf /etc/mysql/conf.d/my.cnf
```

- 이미지 빌드
   + 이미지명: mysql-log-img

```bash
docker image build --tag mysql-log-img .
```

4. Docker 컨테이너 실행
- 컨테이너명: mysql-log
- 볼륨 마운트: mysql_logs -> /var/log/mysql
- 환경변수: MYSQL_ROOT_PASSWORD=1234, MYSQL_DATABASE=testdb
   + 포트: 3306:3306
   + 백그라운드 실행

정답:
```bash
docker container run -d --name mysql-log \
-e MYSQL_ROOT_PASSWORD=1234 \
-e MYSQL_DATABASE=testdb \
-p 3306:3306 \
-v mysql_logs:/var/log/mysql \
mysql-log-img
```

- MySQL 컨테이너 접속

정답:
```bash
mysql --host=127.0.0.1 --port=3306 --user=root --password=1234
```

- MySQL 접속 후 간단 쿼리 명령어 (하나씩 직접 타이핑)
정답: 
```sql
-- 현재 데이터베이스 목록 확인
SHOW DATABASES;

-- 현재 시간 확인
SELECT NOW();

-- 현재 타임존 설정 확인
SELECT @@global.time_zone;

-- MySQL 버전 확인
SELECT VERSION();

-- 현재 사용자 확인
SELECT USER();

-- 현재 설정된 character set 확인
SELECT @@character_set_database;

-- 현재 프로세스 목록 확인
SHOW PROCESSLIST;
```

- 컨테이너 exex 명령어 통해서 쿼리 로그 확인
```bash
docker container exec mysql-log tail -n 10 /var/log/mysql/query.log
...(생략)...
2025-04-19T04:34:00.147326Z         8 Query     SELECT @@character_set_database
2025-04-19T04:34:04.053751Z         8 Query     SHOW PROCESSLIST
2025-04-19T04:34:10.817801Z         8 Quit
```

- 컨테이너, 이미지, 볼륨 삭제
```bash
docker container stop mysql-log
docker container rm mysql-log
docker image rm mysql-log-img
docker volume rm mysql_logs
```

## 9. Bind Mount 
Streamlit을 사용하여 Iris 데이터셋을 시각화하는 애플리케이션을 실행
- 프로젝트 디렉토리: qna09
- 기존에 파일은 모두 작성되어 있음
```bash
qna09/
├── app.py
├── data/
│   └── iris.csv
├── Dockerfile.streamlit
└── requirements.txt
```

- 이미지 빌드 시, Dockerfile.streamlit 사용, 파일명 변경 금지 (==> Dockerfile로 변경 금지)
   + 이미지명: streamlit-app
   + 태그: 1.0.0

정답:
```bash
docker image build --tag streamlit-app:1.0.0 --file Dockerfile.streamlit .
```

- 컨테이너 실행 시, 바인드 마운트 설정
   + 포트: 8501:8501
- 컨테이너명: streamlit-app-container
- 백그라운드 실행
- 종료 시 자동 삭제

정답:
```bash
$ docker container run -d --name streamlit-app-container --rm -p 8501:8501 --mount type=bind,source=$(pwd),target=/app streamlit-app:1.0.0
```

- 위 문법과 아래 문법 차이 비교
```bash
docker container run -d --name streamlit-app-container --rm -p 8501:8501 -v $(pwd):/app streamlit-app:1.0.0
```

- 컨테이너 확인 
```bash
docker container ls
```

- 컨테이너 종료
```bash
docker container stop streamlit-app-container
```

- 컨테이너, 이미지 삭제
```bash
docker container rm streamlit-app-container
docker image rm streamlit-app:1.0.0
```

## 10. 블로그 작성
- 지금까지 작업한 모든 명령어 및 결과 이미지 복사 붙이기 해서 블로그 작성 
- 오후 3시 30분 까지 작성 후 강사 DM으로 전달
