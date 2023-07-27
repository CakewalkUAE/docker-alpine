FROM node:16-alpine
RUN apk --update add postgresql-client
RUN npm install "@getvim/execute"
COPY migrate.js ./
CMD [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

