# 베이스 이미지 지정하기
# FROM [--platform] <image>, ubuntu, python, mysql 입력 가능
FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y vim

# runtime dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
		uuid-dev \
	; \
	rm -rf /var/lib/apt/lists/*