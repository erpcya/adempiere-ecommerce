FROM node:10-alpine

LABEL maintainer="EdwinBetanc0urt@outlook.com; rMunoz@erpya.com; ySenih@erpya.com" \
        description="Front-end e-commerce for ADempiere"

ARG BASE_VERSION="1.12.2"

ENV VS_ENV=prod \
        REPO_NAME="eCommerce" \
        PREFIX="v" \
        URL_REPO="https://github.com/adempiere/eCommerce/archive" \
        BINARY_NAME="$BASE_VERSION" \
        SERVER_HOST="localhost" \
        SERVER_PORT="3000" \
        API_HOST="localhost" \
        API_PORT="8085"
        

WORKDIR /var/www

RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ \
  && apk add --no-cache git \
  && yarn install --no-cache \
  && apk del .build-deps
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    apk --no-cache --update upgrade musl && \
    apk add --no-cache \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
                --virtual .build-deps \
        unzip \
        curl && \
        echo "Downloading ... $URL_REPO/$BASE_VERSION.zip" && \
        curl --output "$BINARY_NAME.zip" \
                -L "$URL_REPO/$PREFIX$BASE_VERSION.zip" && \
        unzip -o $BINARY_NAME.zip && \
        rm $BINARY_NAME.zip && \
        cd $REPO_NAME-$BINARY_NAME && \
        yarn install --no-cache

COPY vue-storefront.sh /usr/local/bin/
COPY default.json /var/www/$REPO_NAME-$BINARY_NAME/config

CMD CMD sed -i "s|SERVER_HOST|$SERVER_HOST|g"  /var/www/$REPO_NAME-$BINARY_NAME/config/default.json && \
    sed -i "s|SERVER_PORT|$SERVER_PORT|g"  /var/www/$REPO_NAME-$BINARY_NAME/config/default.json && \
    sed -i "s|API_HOST|$ES_HOST|g"  /var/www/$REPO_NAME-$BINARY_NAME/config/default.json && \
    sed -i "s|API_PORT|$ES_PORT|g"  /var/www/$REPO_NAME-$BINARY_NAME/config/default.json && \
    sh vue-storefront.sh && tail -f /dev/null
