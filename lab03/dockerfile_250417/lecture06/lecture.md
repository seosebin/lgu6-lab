
# 파이썬 이미지 생성
```bash
docker image build --tag my-python:install .
```

# 파이썬 컨테이너 생성 후, bash 
- 버전 확인
```bash
docker container run --name pytest -it my-python:install bash
```