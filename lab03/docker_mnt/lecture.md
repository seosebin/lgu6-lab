# 컨테이너 실행
```bash
docker container run --name ruby --rm --interactive --tty --mount type=bind,source="$(pwd)",destination=/my-work ruby:3.3.4 bash
```