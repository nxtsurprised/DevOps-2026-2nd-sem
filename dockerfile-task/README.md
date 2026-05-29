# 1) Напишите Dockerfile для создания образа, который будет содержать веб-сервер (Apache или Nginx) и базу данных (MySQL или postgresql)
В Dockerfile должны использоваться инструкции: FROM, MAINTAINER, RUN, CMD, WORKDIR, ENV, ADD, COPY, VOLUME, USER, EXPOSE.
Dockerfile должен содержать комментарии с пояснениями того, что делается. 
Собранный образ должен иметь имя вида <фамилия>_<инициалы>_image_<текущая дата>.
Рядом с dockerfile должен быть скрин, на котором будут видны все слои вашего image и их размер на диске и команда, которой вы это выведете.

Сборка:
<img width="1147" height="937" alt="image" src="https://github.com/user-attachments/assets/3cc7994e-9a09-4db7-ac01-ec67db735e22" />

Запущенный контейнер:
<img width="1135" height="100" alt="image" src="https://github.com/user-attachments/assets/1a76bf95-4aa2-46b5-b81c-3fc94e5d922c" />

Проверка Nginx:
<img width="1131" height="550" alt="image" src="https://github.com/user-attachments/assets/6e6f8661-4623-4caf-bc19-3c18d83684f1" />

Проверка контейнера:
<img width="742" height="165" alt="image" src="https://github.com/user-attachments/assets/9d86d778-d09c-4cc5-916c-f6636292e5e8" />

PostgreSQL внутри контейнера:
<img width="723" height="158" alt="image" src="https://github.com/user-attachments/assets/b0e9f9c1-c047-4435-bd41-ecd3ae9e4a7e" />

Слои и размер:
<img width="775" height="376" alt="image" src="https://github.com/user-attachments/assets/7c9a4dc8-cd0c-4394-85ea-51ee1649ef47" />
