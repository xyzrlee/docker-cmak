#
# Dockerfile for CMAK
#

FROM alpine AS builder

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
 && rm -f cmak.zip \
 && mv `ls -d cmak*` cmak \
 && ls -l /cmak

# ------------------------------------------------

FROM alpine AS builder

COPY --from=builder /cmak /cmak

ADD entrypoint.sh /entrypoint.sh

RUN set -ex \
 && apk add --no-cache \
      openjdk11-jre \
      bash

ENTRYPOINT ["/entrypoint.sh"]

