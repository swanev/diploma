FROM docker.io/library/python:3.9.5-alpine3.13
WORKDIR /app
ADD get_data.py /app/get_data.py
ADD app.py /app/app.py
RUN apk add --no-cache mariadb-connector-c-dev ;\
    apk add --no-cache --virtual .build-deps build-base mariadb-dev ;\
    pip install Flask flask_cors requests mysqlclient;\
    apk del .build-deps 
EXPOSE 5000
entrypoint 'python' 'app.py'