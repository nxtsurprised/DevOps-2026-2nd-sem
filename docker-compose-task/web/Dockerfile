FROM ubuntu:24.04

MAINTAINER Farakhutdinova D.A.

ENV DEBIAN_FRONTEND=noninteractive
ENV APP_HOME=/app
ENV APP_PORT=5000

WORKDIR ${APP_HOME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        python3 \
        python3-pip \
        python3-flask \
        python3-psycopg2 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY app/app.py /app/app.py
COPY app/config/app-config.json /app/config/app-config.json
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    mkdir -p /run/nginx && \
    chown -R www-data:www-data /var/lib/nginx /var/log/nginx /run/nginx

EXPOSE 80

CMD ["/usr/local/bin/docker-entrypoint.sh"]
