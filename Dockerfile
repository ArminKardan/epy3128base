# Use the lightweight Python base image
FROM docker.arvancloud.ir/python:3.12.8-alpine3.21

# Install basic packages (e.g. bash, coreutils, etc.) to make it more usable
RUN apk update && apk add --no-cache \
    bash \
    git \
    curl \
    nano \
    vim \
    iputils \
    net-tools \
    busybox-extras \
    shadow \
    && rm -rf /var/cache/apk/*

RUN apk add maturin
RUN apk add cargo

RUN pip install slixmpp
RUN pip install nest_asyncio bson requests pymongo

COPY ./run.sh /apps/run.sh

WORKDIR /apps/

RUN chmod 777 /apps/run.sh

EXPOSE 3000

CMD ["/bin/sh", "-c", "/apps/run.sh"]


