FROM alpine:3.16
RUN apk --update add postgresql-client
ENTRYPOINT [ "/bin/sh" ]
CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

