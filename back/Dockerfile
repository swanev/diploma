FROM docker.io/library/python:3.9.5-alpine3.13
WORKDIR /app
ARG DB_HOST
ARG DB_USER
ARG DB_PASS
ARG DB_NAME
ENV DB_HOST=${DB_HOST}
ENV DB_USER=${DB_USER}
ENV DB_PASS=${DB_PASS}
ENV DB_NAME=${DB_NAME}
ADD get_data.py /app/get_data.py
ADD app.py /app/app.py
RUN apk add --no-cache mariadb-connector-c-dev ;\
    apk add --no-cache --virtual .build-deps build-base mariadb-dev ;\
    pip install Flask flask_cors requests mysqlclient;\
    apk del .build-deps 
EXPOSE 5000
entrypoint 'python' 'app.py'