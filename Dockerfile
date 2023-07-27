FROM node:alpine
RUN apk --update add postgresql-client
RUN npm install "@getvim/execute"
ENTRYPOINT [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

