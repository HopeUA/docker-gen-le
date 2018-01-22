FROM hope/docker-gen:0.7

LABEL maintainer="Sergii Sadovyi <s.sadovyi@hope.ua>"

ENV \
    SIMPLE_VERSION=0.6.2 \
    LEC_VERSION=1.7 \
    DOCKER_HOST=unix:///var/run/docker.sock \
    DEBUG=false

RUN \
    apk add --no-cache python py-setuptools jq curl && \
    apk add --no-cache --virtual=build-dependencies git gcc py-pip musl-dev libffi-dev python-dev libressl-dev && \
    cd /tmp && \

    # Build simp_le client
    mkdir -p src && \
    git -C src clone --depth=1 --branch ${SIMPLE_VERSION} https://github.com/zenhack/simp_le.git && \
    cd src/simp_le && \

    pip install -U distribute && \
    pip install -U wheel && \
    pip install . && \

    # Copy app files
    mkdir -p /app && \
    git clone --depth=1 --branch v${LEC_VERSION} https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion && \
    cp -r ./docker-letsencrypt-nginx-proxy-companion/app/* /app  && \

    # Cleanup
    apk del build-dependencies && \
    rm -rf /tmp/*

WORKDIR /app

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
CMD ["/bin/bash", "/app/start.sh"]
