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
