FROM node:18-alpine3.15

WORKDIR /app
COPY . /app

RUN apk update \
    && apk add bash git g++ make python3 \
    && yarn global add firebase-tools

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

