# Volume 생성

- 볼륨 생성
```bash
docker volume create --name my-volume
```

- 볼륨 목록 확인
```bash
docker volume ls
```

# 볼륨 마운트하기
- 컨테이너 생성 시, 볼륨 마운트
- docker container [OPTIONS] : `--mount`
    + 링크 : 
```bash
docker container --(생략)-- \
--mount type=volume,source=my-volume,destination=/my-work
```

# 텍스트 파일 생성
생성한 볼륨에 저장함.
```bash
root@7e23ee8a1bad:/# echo 'hello World From container, volume' > /my-work/hello.txt
root@7e23ee8a1bad:/# ls /my-work/
hello.txt
```

- 다른 컨테이너 생성해서 확인 시, 동일한 파일 확인되어야 함
```bash
docker container run --name ubuntu2 --rm --interactive --tty --mount type=volume,source=my-volume,destination=/my-work ubuntu:24.04
```

- volume 지우기
```bash
docker volume rm my-volume
```

# 새로운 볼륨 작성 후, MySQL 컨테이너에 마운트하기
```bash
docker volume create --name db-volume
```

- MySQL 설정 파일 
    + 중간에 datadir 경로를 복사
```bash
$ docker container run --rm mysql:8.4.2 cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.4/en/server-configuration-defaults.html
[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
```

- 볼륨 마운트에서 MySQl 컨테이너 가동하기
```bash
docker container run \
> --name db1 \
> --rm \
> --detach \
> --env MYSQL_ROOT_PASSWORD=1234 \
> --env MYSQL_DATABASE=sample \
> --publish 3306:3306 \
> --mount type=volume,source=db-volume,destination=/var/lib/mysql \
> mysql:8.4.2
```

- MYSQL 접속
```bash
mysql --host=127.0.0.1 --port=3306 --user=root --password=1234 sample
```

- DB 생성 및 데이터 추가
```bash
create table user ( id int, name varchar(32) );
insert into user ( id, name) values (1, 'John' );
insert into user ( id, name) values (2, 'Evan' );
select * from user;
+------+------+
| id   | name |
+------+------+
|    1 | John |
|    2 | Evan |
+------+------+
2 rows in set (0.00 sec)
```

# DB 볼륨 확인 
- 환경변수가 불필요함 (이유 : Volume 데이터안에 db1의 myql 정보가 같이 저장됨)
- 두번째부터 컨테이너 생성활 때는 굳이 환경변수 지정을 안해도 됨
```bash
$ docker container run --name db2 --rm --detach --publi
sh 3306:3306 --mount type=volume,source=db-volume,destination=/var/lib/mysql mysql:8.4.2
cf8db83b80b46eb206edb87b1ea468d83bcb1e8100f9dad1f680527a6007fe8e
```
- 접속 방법 동일함
```bash
mysql --host=127.0.0.1 --port=3306 --user=root --password=1234 sample
```

- 실제 저장된 정보가 있는지 재확인
```bash
mysql> select * from user;
+------+------+
| id   | name |
+------+------+
|    1 | John |
|    2 | Evan |
+------+------+
2 rows in set (0.00 sec)
```