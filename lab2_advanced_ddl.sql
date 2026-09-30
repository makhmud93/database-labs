-- Task 1: Conditional INSERT
INSERT INTO employees (first_name, last_name, department, salary)
SELECT 'Timur', 'Zhakenov', 'Sales', 550000
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Timur'
      AND last_name = 'Zhakenov'
);


-- Task 2: UPDATE with CASE
UPDATE employees
SET bonus_pct = CASE
    WHEN salary > 800000 THEN 15
    WHEN salary > 500000 THEN 10
    ELSE 5
END;


-- Task 3: UPDATE with subquery
UPDATE departments d
SET budget = (
    SELECT SUM(e.salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
)
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department = d.dept_name
);


-- Task 4: Data migration, part 1
CREATE TABLE employee_archive AS
SELECT *
FROM employees
WHERE status = 'Inactive';


-- Task 5: Data migration, part 2
DELETE FROM employees
WHERE status = 'Inactive'
RETURNING emp_id, first_name  ' '  last_name AS full_name;




-- TASK 1: INSERT with expressions

INSERT INTO projects
    (project_name, budget, start_date, end_date, total_tasks, done_tasks)
VALUES
    ('Mobile App',
     400000 * 1.25,
     CURRENT_DATE,
     CURRENT_DATE + 90,
     12,
     0)
RETURNING project_id, budget, start_date, end_date;


-- TASK 2: UPDATE with NULL

UPDATE team_members
SET status = 'Unassigned'
WHERE project_id IS NULL
RETURNING full_name, status;


-- TASK 3: UPDATE with arithmetic

UPDATE projects
SET completion_pct = CASE
    WHEN total_tasks = 0 THEN 0
    ELSE ROUND(done_tasks * 100.0 / total_tasks, 1)
END;


-- TASK 4: UPDATE with subquery

UPDATE projects p
SET end_date = p.end_date + 30
WHERE p.budget > 500000
  AND (
      SELECT COUNT(*)
      FROM team_members t
      WHERE t.project_id = p.project_id
  ) > 2
RETURNING project_name, end_date;


-- TASK 5: DELETE with subquery

DELETE FROM team_members t
WHERE t.project_id IN (
    SELECT p.project_id
    FROM projects p
    WHERE p.end_date < DATE '2026-01-01'
)
RETURNING *;
