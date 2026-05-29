# Напишите docker compose конфиг, для разворачивания двух контейнеров в одной сети (10.10.10.0/28) типа bridge
Nginx или Apache + ваше самописное web приложение на выбор (подойдет даже "заглушка" методу get), ему должны передаваться конфигурационные файлы через volume, nginx открыт на 80 порту и должен быть доступен из контейнера на хостовой машине по порту 8080
mysql или postgres, каталог для хранения данных должен монтироваться как docker volume, docker volume должен быть описан в том же конфигурационном файле docker compose. Сервис с БД должен быть доступен из контейнера с веб-сервером по именам new_db, dev_db.
Должна быть задана очередность запуска сервисов


# Ход работы
Собран образ для веб-контейнера, создана сеть проекта, создан volume для данных PostgreSQL. Запущены контейнеры compose_web_container и compose_db_container.
<img width="1134" height="498" alt="image" src="https://github.com/user-attachments/assets/55cb67aa-1640-416f-ac0c-42e150c33525" />

Запрос к корневому адресу вернул JSON-ответ от веб-приложения.

/health – приложение работает.

/db-check – веб-контейнер подключается к PostgreSQL по имени new_db и получает данные из таблицы.

<img width="906" height="595" alt="image" src="https://github.com/user-attachments/assets/aa5588d4-118c-4d36-b713-60e3192449e9" />

Сеть создана с драйвером bridge и имеет подсеть 10.10.10.0/28. Также отображаются подключенные контейнеры compose_web_container и compose_db_container с IP-адресами внутри заданной подсети.
<img width="876" height="830" alt="image" src="https://github.com/user-attachments/assets/bea25ef5-da30-442d-b179-f2a4c5aea89b" />

volume docker-compose-task_postgres_data создан локальным драйвером Docker и используется для хранения данных PostgreSQL в каталоге /var/lib/docker/volumes/..
<img width="849" height="252" alt="image" src="https://github.com/user-attachments/assets/f812c624-26e1-4963-9468-ed97794ad3d9" />
