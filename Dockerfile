FROM node:16-alpine
RUN apk --update add postgresql-client
RUN npm install -g "@getvim/execute"
CMD [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

