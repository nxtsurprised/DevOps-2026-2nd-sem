# Задание по Ansible roles

Та же постановка задачи что и на Ansible, но плюсом:
- Реализовать надо как несколько ansible role (задачи по пользователю отдельно, настройки ssh отдельно). 
- Создаваемые пользователи и их открытые ключи для авторизации должны быть определены через vars
- Должно быть тестирование ролей через molecule (рекомендую выбрать  Driver/Provider docker)

# Ход работы
## Подготовка
Для проверки использовался localhost в Ubuntu VM как целевой хост.
Установила зависимости Docker, Python venv, molecule и ansible-lint.
Создаваемые пользователи, SSH-ключи и директории задаются через переменные в `group_vars/all.yml`.

## Результат
Запуск playbook через роли:
<img width="1189" height="863" alt="image" src="https://github.com/user-attachments/assets/3499c7ca-58d0-4dfd-8e67-198e0467dffe" />

Проверка пользователя, sudo и ключа:
<img width="1025" height="291" alt="image" src="https://github.com/user-attachments/assets/f12d78de-b708-4d9f-8581-0d8b165a372f" />

Проверка SSH-настроек:
<img width="1191" height="252" alt="image" src="https://github.com/user-attachments/assets/cbe7780f-9a15-4fc4-9bbf-7730427f85e8" />

drw-rw---- и Permission denied, exit_code=1:
<img width="932" height="176" alt="image" src="https://github.com/user-attachments/assets/b215be96-ba0f-4898-a364-703e32d61f9c" />

Выполнение Molecule для Users:
<img width="1017" height="767" alt="image" src="https://github.com/user-attachments/assets/81ff06ab-a262-447e-83d7-5cd72b56132e" />

Выполнение Molecule для ssh:
<img width="1194" height="849" alt="image" src="https://github.com/user-attachments/assets/9fe5167f-8e45-48dd-9890-6fcc9392600f" />
