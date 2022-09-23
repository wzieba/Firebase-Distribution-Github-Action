FROM node:18-alpine3.15

WORKDIR /app
COPY . /app

RUN yarn global add firebase-tools \
    && apk update \
    && apk add git 

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

