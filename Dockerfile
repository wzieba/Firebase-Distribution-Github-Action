FROM node:12.10.0-alpine

WORKDIR /app
COPY . /app

RUN npm install -g firebase-tools \
    && apk update \
    && apk add git 

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

