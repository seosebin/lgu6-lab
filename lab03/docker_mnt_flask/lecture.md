# 파일 구조
- 파이썬 Flask에서 실행파일 매우 기본적인 구조
```bash
$ tree
.
├── app.py
└── templates
    └── index.html
```

# 시나리오
- 1차 : 컨테이너 실행된 상태에서 HTML 파일 변경 후, 실제 웹에서 변경된 사항 확인
- 2차 : Dockerfile 생성 후, 1차 재확인
- 3차 : 테스트 완료 ==> 배포 (이미지 배포)
- 4차 : 자동화 (deploy.sh) 활용해서, 배포 완료 후, 다시 테스트 컨테이너 생성 (Tag 업데이트)

# 컨테이너 실행
```bash
docker container run --rm -it --publish 5000:5000 --mount type=bind,source="$(pwd)",destination=/app -w /app python:3.10-slim bash -c "pip install flask && python app.py"
```

# Dorkerfile 이미지 만들기
- Dorkerfile 확인\
```bash
docker image build --tag seosebin/my-flask-web:1.0.0 .
```

## 컨테이너 실행
- 반드시 Dockfile에 기재한 WORKDIR와 동일한 destination 경로 설정
```bash
docker container run --rm -it -p 5000:5000 --mount type=bind,source="$(pwd)",destination=/app seosebin/my-flask-web:1.0.0
```