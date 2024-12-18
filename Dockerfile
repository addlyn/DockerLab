FROM python:3.12-alpine

WORKDIR /opt/pgadmin

ARG USER=pgadmin
ARG GROUP=pgadmin
ENV USER=$USER
ENV GROUP=$GROUP

# создание пользователя и каталогов
RUN addgroup -S $GROUP && \
    adduser -D -S -s /sbin/nologin -G $GROUP $USER && \
    mkdir /var/lib/pgadmin && \
    mkdir /var/log/pgadmin && \
    mkdir /opt/pgadmin/config && \
    mkdir /opt/pgadmin/storage && \
    chown $USER:$GROUP /var/lib/pgadmin && \
    chown $USER:$GROUP /var/log/pgadmin && \
    chown -R $USER:$GROUP /opt/pgadmin

# установка pgAdmin4
RUN apk add --no-cache alpine-sdk linux-headers && \ 
    pip install --upgrade pip && \
    pip install https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v8.10/pip/pgadmin4-8.10-py3-none-any.whl && \
    apk del alpine-sdk linux-headers

# копируем файл конфигурации (там определен каталог на /opt/pgadmin и порт по умолчанию 5050)
COPY config_distro.py /usr/local/lib/python3.12/site-packages/pgadmin4/

EXPOSE 5050
VOLUME /opt/pgadmin

# запуск от имени созданного пользователя
USER $USER:$GROUP
CMD ["python", "/usr/local/lib/python3.12/site-packages/pgadmin4/pgAdmin4.py"]
