# FROM alpine:latest
# RUN apk --update add postgresql-client
# RUN apk add ioping
# RUN apk add fio
# RUN apk add traceroute
# CMD [ "/bin/sh"]

FROM postgres:17
WORKDIR /app

RUN apt-get update && apt-get install -y pgcopydb

COPY . .
RUN chmod +x run.sh
ENTRYPOINT ["/bin/sh"]
