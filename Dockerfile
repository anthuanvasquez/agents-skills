FROM alpine:latest

RUN apk add --no-cache bash git curl
RUN adduser -D test

USER test

WORKDIR /home/test

ENV SHELL=/bin/bash

CMD ["tail", "-f", "/dev/null"]
