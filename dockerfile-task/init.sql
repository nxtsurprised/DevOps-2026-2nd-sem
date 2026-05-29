CREATE TABLE IF NOT EXISTS task_info (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL
);

INSERT INTO task_info (description)
SELECT 'Dockerfile task initialized'
WHERE NOT EXISTS (
    SELECT 1 FROM task_info WHERE description = 'Dockerfile task initialized'
);
