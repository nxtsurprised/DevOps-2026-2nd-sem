# Docker Compose task

## Описание

В рамках задания подготовлен `docker-compose.yml`, который разворачивает два контейнера в одной bridge-сети:

- `web` - контейнер с Nginx и простым самописным Python Flask web-приложением;
- `db` - контейнер с PostgreSQL.

Сеть задана явно:

```text
10.10.10.0/28
```

Nginx слушает порт `80` внутри контейнера и доступен с хостовой машины по порту `8080`.

## Почему Nginx и web-приложение находятся в одном контейнере

В задании указано развернуть два контейнера: web-сервис и базу данных. Поэтому Nginx и простое web-приложение размещены в одном контейнере `web`.

В реальных проектах Nginx, приложение и база данных обычно разделяются по разным контейнерам. Здесь реализация сделана буквально под условие учебного задания.

## Структура

```text
docker-compose-task/
├── docker-compose.yml
├── README.md
├── web/
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   ├── nginx/
│   │   └── default.conf
│   └── app/
│       ├── app.py
│       └── config/
│           └── app-config.json
└── db/
    └── init.sql
```

## Что выполнено по условию

- создано два контейнера;
- контейнеры находятся в одной bridge-сети;
- сеть имеет подсеть `10.10.10.0/28`;
- Nginx открыт на порту `80`;
- с хостовой машины сервис доступен по порту `8080`;
- конфигурационные файлы для web-сервиса передаются через `volume`;
- данные PostgreSQL хранятся в Docker volume `postgres_data`;
- Docker volume описан в `docker-compose.yml`;
- сервис БД доступен из web-контейнера по именам `new_db` и `dev_db`;
- задана очередность запуска сервисов через `depends_on` и `healthcheck`.

## Запуск

Из папки `docker-compose-task`:

```bash
docker compose up -d --build
```

Если используется старая команда Compose:

```bash
docker-compose up -d --build
```

## Проверка контейнеров

```bash
docker compose ps
```

Ожидаемо должны быть запущены два контейнера:

```text
compose_web_container
compose_db_container
```

## Проверка web-сервиса с хоста

```bash
curl http://localhost:8080
curl http://localhost:8080/health
curl http://localhost:8080/db-check
```

Ожидаемый смысл результата:

- `/` возвращает JSON-ответ от web-приложения;
- `/health` возвращает статус приложения;
- `/db-check` проверяет подключение web-контейнера к PostgreSQL.

## Проверка доступности БД по имени `new_db`

```bash
docker exec -it compose_web_container python3 - << 'PY'
import os
import psycopg2

connection = psycopg2.connect(
    host="new_db",
    port="5432",
    dbname="student_db",
    user="student_user",
    password="student_password",
)

with connection:
    with connection.cursor() as cursor:
        cursor.execute("SELECT description FROM compose_task_info LIMIT 1;")
        print(cursor.fetchone())
PY
```

## Проверка доступности БД по имени `dev_db`

```bash
docker exec -it compose_web_container python3 - << 'PY'
import psycopg2

connection = psycopg2.connect(
    host="dev_db",
    port="5432",
    dbname="student_db",
    user="student_user",
    password="student_password",
)

with connection:
    with connection.cursor() as cursor:
        cursor.execute("SELECT description FROM compose_task_info LIMIT 1;")
        print(cursor.fetchone())
PY
```

## Проверка сети

```bash
docker network ls
docker network inspect docker-compose-task_compose_task_network
```

В выводе должна быть подсеть:

```text
10.10.10.0/28
```

## Проверка Docker volume

```bash
docker volume ls
docker volume inspect docker-compose-task_postgres_data
```

## Логи

```bash
docker compose logs web
docker compose logs db
```

## Остановка

```bash
docker compose down
```

Остановка с удалением volume PostgreSQL:

```bash
docker compose down -v
```

Команду `down -v` использовать только если данные БД больше не нужны.

## Скриншоты для сдачи

Рекомендуемые скриншоты:

```text
screenshots/docker-compose-task/01_compose_up.png
screenshots/docker-compose-task/02_compose_ps.png
screenshots/docker-compose-task/03_curl_checks.png
screenshots/docker-compose-task/04_network_inspect.png
screenshots/docker-compose-task/05_volume_inspect.png
screenshots/docker-compose-task/06_db_alias_check.png
```
