# 파이썬 컨테이너 웹서버 활용

# CMD 명령어 배우기
- 컨테이너 가동 시 명령어 지정
```bash
docker container run --name py-web --rm --detach --publish 8000:8000 python:3.12.5 python3 -m http.server
```

- CMD 명령어 
CMD ['executable', 'param1', 'param2']