import json
import os

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)


def load_config():
    config_path = os.environ.get("APP_CONFIG_PATH", "/app/config/app-config.json")
    with open(config_path, "r", encoding="utf-8") as config_file:
        return json.load(config_file)


def get_db_connection():
    return psycopg2.connect(
        host=os.environ.get("DB_HOST", "new_db"),
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ.get("DB_NAME", "student_db"),
        user=os.environ.get("DB_USER", "student_user"),
        password=os.environ.get("DB_PASSWORD", "student_password"),
    )


@app.get("/")
def index():
    config = load_config()
    return jsonify(
        {
            "status": "ok",
            "message": config.get("message", "Docker Compose web app is running"),
            "service": config.get("service", "compose-web-app"),
        }
    )


@app.get("/health")
def health():
    return jsonify({"status": "healthy"})


@app.get("/db-check")
def db_check():
    with get_db_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT description FROM compose_task_info LIMIT 1;")
            row = cursor.fetchone()

    return jsonify(
        {
            "status": "ok",
            "db_host": os.environ.get("DB_HOST", "new_db"),
            "db_result": row[0] if row else None,
        }
    )


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
