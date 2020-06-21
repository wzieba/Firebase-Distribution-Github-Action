FROM node:14.4.0-alpine3.12

WORKDIR /app
COPY . /app

RUN yarn global add firebase-tools \
    && apk update \
    && apk add git 

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

