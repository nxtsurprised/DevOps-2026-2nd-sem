FROM ubuntu:24.04

MAINTAINER D A Farakhutdinova

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV APP_HOME=/opt/dockerfile_task
ENV POSTGRES_DB=student_db
ENV POSTGRES_USER=student_user
ENV POSTGRES_PASSWORD=student_password

# Set working directory for application files
WORKDIR ${APP_HOME}

# Install Nginx, PostgreSQL and helper tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        postgresql \
        postgresql-contrib \
        gosu \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Non-root application user
RUN useradd -m -s /bin/bash appuser && \
    mkdir -p ${APP_HOME} /docker-entrypoint-initdb.d && \
    chown -R appuser:appuser ${APP_HOME}

# Configuration and startup script
COPY nginx.conf /etc/nginx/sites-available/default
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ADD index.html /var/www/html/index.html

# An initialization SQL script into the image
ADD init.sql /docker-entrypoint-initdb.d/init.sql

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown -R www-data:www-data /var/www/html && \
    chown -R postgres:postgres /docker-entrypoint-initdb.d

# Volumes for database data and Nginx logs
VOLUME ["/var/lib/postgresql", "/var/log/nginx"]

# Web server and PostgreSQL ports
EXPOSE 80
EXPOSE 5432

# Container starts both Nginx and PostgreSQL services
USER root

# Start PostgreSQL and Nginx
CMD ["/usr/local/bin/docker-entrypoint.sh"]
