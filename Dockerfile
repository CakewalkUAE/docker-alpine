FROM postgres:alpine
#RUN apk --update add postgresql-client
ENTRYPOINT [ "/bin/sh","pg_dump abc.com" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

