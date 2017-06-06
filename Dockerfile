FROM hope/docker-gen

ENV \
    SIMPLE_VERSION=0.2.0 \
    DOCKER_HOST=unix:///var/run/docker.sock \
    DEBUG=false

RUN \
    apk add --no-cache python py-requests py-setuptools libssl1.0 procps jq curl && \
    apk add --no-cache --virtual=build-dependencies git gcc py-pip musl-dev libffi-dev python-dev openssl-dev && \
    cd /tmp && \

    # Build simp_le client
    mkdir -p src && \
    git -C src clone --depth=1 --branch ${SIMPLE_VERSION} https://github.com/zenhack/simp_le.git && \
    cd src/simp_le && \
    python ./setup.py install && \

    # Cleanup
    apk del build-dependencies && \
    rm -rf /tmp/*

COPY rootfs/ /
WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]
