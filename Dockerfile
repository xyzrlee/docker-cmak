#
# Dockerfile for shadowsocks-libev
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

ADD entrypoint.sh /entrypoint.sh

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      git \
      openjdk11-jdk \
      unzip \
 # Build & install
 && git clone https://github.com/yahoo/CMAK.git /tmp/repo/CMAK \
 && cd /tmp/repo/CMAK \
 && ./sbt clean dist \
 && cd target/universal \
 && mv `ls cmak*.zip` /cmak.zip \
 && cd / \
 && unzip cmak.zip \
 && rm cmak.zip \
 && mv `ls -d cmak*` cmak \
 && ls -l /cmak \
 && rm -rf /tmp/repo \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      openjdk11-jre \
      bash

ENTRYPOINT ["/entrypoint.sh"]

