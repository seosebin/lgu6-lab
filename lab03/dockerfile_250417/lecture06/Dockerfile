# Python 이미지 기반
FROM python:3.10-slim 

# 작업 디렉터리 설정
WORKDIR /app

# 패키지 목록 복사 
COPY requirements.txt . 

# 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt 
