FROM mysql
COPY ./dockerfile/database/init.sql /docker-entrypoint-initdb.d/