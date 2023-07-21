FROM alpine:3.16
RUN apk --update add postgresql-client
ENTRYPOINT [ "psql" ]
