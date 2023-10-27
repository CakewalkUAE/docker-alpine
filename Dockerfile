FROM alpine:latest
RUN apk --update add postgresql-client
RUN apk add ioping
RUN apk add fio
RUN apk add traceroute
CMD [ "/bin/sh"]
