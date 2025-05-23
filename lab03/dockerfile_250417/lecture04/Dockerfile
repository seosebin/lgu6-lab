FROM ubuntu:24.04

#### ---- 설치 확인 용도 ---- ####
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    mysql-server \
    mysql-client \
    postgresql \
    postgresql-client \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*
