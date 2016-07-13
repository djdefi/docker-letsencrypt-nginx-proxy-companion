FROM djdefi/rpi-alpine

MAINTAINER Yves Blusseau <90z7oey02@sneakemail.com> (@blusseau)

ENV DEBUG=false              \
	DOCKER_GEN_VERSION=0.7.0 \
	DOCKER_HOST=unix:///var/run/docker.sock

RUN apk update && apk upgrade && apk --update add bash curl ca-certificates procps jq tar python git gcc py-pip musl-dev libffi-dev python-dev openssl-dev && \
	pip install --upgrade pip && \
	pip install requests && \
	pip install --upgrade setuptools && \
	curl -L -O https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	tar -C /usr/local/bin -xvzf docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	rm -f docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	apk del tar && \
	rm -rf /var/cache/apk/*

WORKDIR /app

# Install simp_le program
COPY /install_simp_le.sh /app/install_simp_le.sh
RUN chmod +rx /app/install_simp_le.sh && sync && /app/install_simp_le.sh && rm -f /app/install_simp_le.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]

COPY /app/ /app/
