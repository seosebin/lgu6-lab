# 컨테이너 실행
- 임의의 mysql 컨테이너 실행
```bash
$ docker container run \
> --name db \
> --rm \
> --detach \
> --env MYSQL_ROOT_PASSWORD=1234 \
> --publish 3307:3306 \
> mysql:9.0.1
```

# mysql 접속
```bash
mysql --host=127.0.0.1 --port=3307 --user=root --password=1234
```

- 시간대 변경
```bash
mysql> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | UTC    |
| time_zone        | SYSTEM |
+------------------+--------+
2 rows in set (0.01 sec)
``` 

- 현재 시간 확인
```bash
mysql> SELECT now();
+---------------------+
| now()               |
+---------------------+
| 2025-04-17 03:22:29 |
+---------------------+
1 row in set (0.01 sec)
```

- 시간 변경 후 적용
```bash
mysql> SET time_zone = 'Asia/Seoul';
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT now();        
+---------------------+
| now()               |
+---------------------+
| 2025-04-17 12:23:14 |
+---------------------+
1 row in set (0.00 sec)
```

- MySQL 컨테이너 환경변수 확인 (현재 실행중인 컨테이너 확인)
```bash
$ docker container exec db printenv TZ
```


# Dockerfile 적용
- Dockerfile 확인

# Dockerfile 이미지 생성
```bash
docker image build --file Dockerfile.ubuntu --tag my-sql:temp .
docker images
docker image build --file Dockerfile.mysql --tag my-sql:TZ .
```

- 컨테이너 확인
    + 아래는 실행해도 안 나옴
```bash
docker container run --name db2 --rm --detach --env MYSQL_ROOT_PASSWORD=1234 --publish 3308:3306 my-sql:temp
```

- 실행되는 것
```bash
docker container run --name db3 --rm --detach --env MYSQL_ROOT_PASSWORD=1234 --publish 3309:3306 my-sql:TZ
```