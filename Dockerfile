FROM node:alpine
RUN apk --update add postgresql-client
ENTRYPOINT [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

