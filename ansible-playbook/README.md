# Задание по Ansible:

Написать playbook который должен будет:
- Создать пользователя на удаленной машине.
- Дать пользователю права sudo.
- Сделать авторизацию ssh по ключам для пользователя.
- Отключить авторизацию по паролю при ssh подключении.
- Создать директорию в /opt/ с правами 660 для пользователя.

# Ход работы
Для проверки использовался localhost в Ubuntu VM как целевой хост. В inventory указан ansible_connection=local, поэтому Ansible применяет задачи к той же машине, на которой запускается.
<img width="1142" height="912" alt="image" src="https://github.com/user-attachments/assets/f0fbd387-349d-4574-8682-6a4ab8f4cace" />

<img width="1311" height="569" alt="image" src="https://github.com/user-attachments/assets/df027e20-0848-4dab-ad8d-9154a2ebf732" />


