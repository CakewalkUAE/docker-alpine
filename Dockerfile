FROM node:16-alpine
RUN apk --update add postgresql-client
RUN mkdir -p /user/app
WORKDIR /user/app
COPY migrate.js /user/app
RUN npm install "@getvim/execute"
CMD [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

