CREATE TABLE IF NOT EXISTS compose_task_info (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL
);

INSERT INTO compose_task_info (description)
SELECT 'Docker Compose task initialized'
WHERE NOT EXISTS (
    SELECT 1
    FROM compose_task_info
    WHERE description = 'Docker Compose task initialized'
);
