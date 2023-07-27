#FROM node:16-alpine
#RUN apk --update add postgresql-client
#RUN mkdir -p /user/app
#WORKDIR /user/app
#COPY migrate.js /user/app
#RUN npm install "@getvim/execute"
#CMD [ "node","migrate.js" ]
#CMD ["pg_dump","-O",$fromDB,"|","psql",$toDB]

FROM alpine:3.16
RUN apk --update add postgresql-client
COPY importpg.sh /
CMD [ "importpg.sh" ]
