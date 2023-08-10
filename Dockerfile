FROM alpine:3.16
RUN apk --update add postgresql-client
RUN apk add ioping
CMD [ "sh"]
