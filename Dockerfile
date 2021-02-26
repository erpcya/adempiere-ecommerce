FROM node:10-alpine

LABEL maintainer="EdwinBetanc0urt@outlook.com; rMunoz@erpya.com; ySenih@erpya.com" \
        description="Front-end e-commerce for ADempiere"

ENV VS_ENV=prod \
        REPO_NAME="eCommerce" \
        URL_REPO="https://github.com/adempiere/eCommerce.git" \
        SERVER_PORT="3000" \
        API_URL="http:\/\/localhost:8085" \
        STORE_INDEX="vue_storefront_catalog" \
        MEMORY_RESTART="1G" \
        EXEC_INSTANCES="4"

WORKDIR /var/www

RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ \
  && apk add --no-cache git \
  && yarn install --no-cache \
  && apk del .build-deps && \
    apk --no-cache --update upgrade musl && \
    apk add --no-cache \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
                --virtual .build-deps \
     unzip \
     curl && \
     echo "Downloading ... $URL_REPO" && \
     git clone $URL_REPO && \
     cd $REPO_NAME && \
     git submodule add -b master https://github.com/DivanteLtd/vsf-capybara.git src/themes/capybara && \
     git submodule update --init --remote && \
     sed -i "s|src/themes/default/|src/themes/capybara|g"  /var/www/$REPO_NAME/tsconfig.json && \
     cd  /var/www/$REPO_NAME/src/themes/capybara &&  yarn && \
     node  /var/www/$REPO_NAME/src/themes/capybara/scripts/generate-local-config.js && \
     cd /var/www/$REPO_NAME/  && npm install -g lerna && \
     chmod -R 777 /var/www/$REPO_NAME
COPY default.json /var/www/$REPO_NAME/config
COPY ecosystem.json /var/www/$REPO_NAME

CMD sed -i "s|SERVER_HOST|$(hostname)|g"  /var/www/$REPO_NAME/config/default.json && \
    sed -i "s|SERVER_PORT|$SERVER_PORT|g"  /var/www/$REPO_NAME/config/default.json && \
    sed -i "s|API_URL|$API_URL|g"  /var/www/$REPO_NAME/config/default.json && \
    sed -i "s|vue_storefront_catalog|$STORE_INDEX|g"  /var/www/$REPO_NAME/config/default.json && \
    sed -i "s|MEMORY_RESTART|$MEMORY_RESTART|g"  /var/www/$REPO_NAME/ecosystem.json && \
    sed -i "s|EXEC_INSTANCES|$EXEC_INSTANCES|g"  /var/www/$REPO_NAME/ecosystem.json && \
    cd /var/www/$REPO_NAME/ && \
    /usr/local/bin/lerna bootstrap && yarn build && yarn start && tail -f /dev/null
