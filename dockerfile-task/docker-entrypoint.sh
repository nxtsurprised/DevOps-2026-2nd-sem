#!/usr/bin/env bash
set -e

echo "Starting PostgreSQL..."

POSTGRES_VERSION="$(ls /etc/postgresql | head -n 1)"
POSTGRES_CLUSTER_DIR="/etc/postgresql/${POSTGRES_VERSION}/main"

if [ -z "$POSTGRES_VERSION" ]; then
    echo "PostgreSQL cluster was not found."
    exit 1
fi

pg_ctlcluster "$POSTGRES_VERSION" main start

echo "Waiting for PostgreSQL to become ready..."

until gosu postgres pg_isready > /dev/null 2>&1; do
    sleep 1
done

echo "PostgreSQL is ready."

if ! gosu postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${POSTGRES_USER}'" | grep -q 1; then
    gosu postgres psql -c "CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}';"
fi

if ! gosu postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'" | grep -q 1; then
    gosu postgres psql -c "CREATE DATABASE ${POSTGRES_DB} OWNER ${POSTGRES_USER};"
fi

if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    echo "Applying init.sql..."
    gosu postgres psql -d "${POSTGRES_DB}" -f /docker-entrypoint-initdb.d/init.sql || true
fi

echo "Starting Nginx..."

exec nginx -g "daemon off;"
