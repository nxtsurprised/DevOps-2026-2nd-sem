#!/usr/bin/env bash
set -e

echo "Starting simple Python web application..."
python3 /app/app.py &

echo "Starting Nginx..."
exec nginx -g "daemon off;"
