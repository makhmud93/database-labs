-- ============================================================
-- Лабораторная работа №5: Database Constraints (PostgreSQL)
-- Студент: ______________________
-- Student ID: ___________________
--
-- ВНИМАНИЕ:
-- 1. Скрипт предназначен для PostgreSQL.
-- 2. Некорректные INSERT/DELETE приведены в комментариях, чтобы
--    выполнение всего файла не остановилось на ошибке.
-- 3. Для проверки нарушений снимайте комментарии с теста по одному.
-- ============================================================

-- ============================================================
-- PART 1. CHECK CONSTRAINTS
-- ============================================================

-- Task 1.1. Возраст 18–65, зарплата больше 0.
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CONSTRAINT employees_age_check CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CONSTRAINT employees_salary_check CHECK (salary > 0)
);

INSERT INTO employees VALUES
(1, 'Ivan', 'Petrov', 25, 250000),
(2, 'Anna', 'Sidorova', 42, 380000);

-- Ошибки для проверки (по одной):
-- INSERT INTO employees VALUES (3, 'Bad', 'Age', 17, 100000);
-- Нарушается employees_age_check: возраст меньше 18.
-- INSERT INTO employees VALUES (4, 'Bad', 'Salary', 30, 0);
-- Нарушается employees_salary_check: зарплата должна быть > 0.

-- Task 1.2. Именованное ограничение valid_discount.
DROP TABLE IF EXISTS products_catalog CASCADE;
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
    )
);

INSERT INTO products_catalog VALUES
(1, 'Keyboard', 15000, 12000),
(2, 'Mouse', 8000, 6500);

-- Ошибки для проверки (по одной):
-- INSERT INTO products_catalog VALUES (3, 'Bad price', 0, 5);
-- valid_discount: regular_price должен быть > 0.
-- INSERT INTO products_catalog VALUES (4, 'Bad discount', 100, 0);
-- valid_discount: discount_price должен быть > 0.
-- INSERT INTO products_catalog VALUES (5, 'No discount', 100, 100);
-- valid_discount: discount_price должен быть меньше regular_price.

-- Task 1.3. Ограничения для бронирований.
DROP TABLE IF EXISTS bookings CASCADE;
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER,
    CONSTRAINT bookings_guests_check CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT bookings_dates_check CHECK (check_out_date > check_in_date)
);

INSERT INTO bookings VALUES
(1, DATE '2026-11-01', DATE '2026-11-05', 2),
(2, DATE '2026-12-10', DATE '2026-12-12', 5);

-- Ошибки для проверки (по одной):
-- INSERT INTO bookings VALUES (3, DATE '2026-11-01', DATE '2026-11-05', 0);
-- bookings_guests_check: гостей должно быть от 1 до 10.
-- INSERT INTO bookings VALUES (4, DATE '2026-11-05', DATE '2026-11-05', 2);
-- bookings_dates_check: дата выезда должна быть позже даты заезда.

-- Проверка корректных данных:
SELECT * FROM employees;
SELECT * FROM products_catalog;
SELECT * FROM bookings;


-- ============================================================
-- PART 2. NOT NULL CONSTRAINTS
-- ============================================================

-- Task 2.1. Обязательные поля клиента.
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT, -- NULL разрешён
    registration_date DATE NOT NULL
);

INSERT INTO customers VALUES
(1, 'ivan@example.com', '+77010000001', DATE '2026-09-01'),
(2, 'anna@example.com', NULL, DATE '2026-09-15');

-- Ошибки для проверки (по одной):
-- INSERT INTO customers VALUES (NULL, 'x@example.com', NULL, DATE '2026-10-01');
-- customer_id запрещено оставлять NULL.
-- INSERT INTO customers VALUES (3, NULL, '+77010000003', DATE '2026-10-01');
-- email запрещено оставлять NULL.
-- INSERT INTO customers VALUES (4, 'y@example.com', NULL, NULL);
-- registration_date запрещено оставлять NULL.

-- Task 2.2. NOT NULL + CHECK для склада.
DROP TABLE IF EXISTS inventory CASCADE;
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO inventory VALUES
(1, 'Bandage', 100, 250.00, TIMESTAMP '2026-10-01 09:00:00'),
(2, 'Gloves', 50, 120.00, TIMESTAMP '2026-10-02 10:30:00');

-- Ошибки для проверки:
-- INSERT INTO inventory VALUES (NULL, 'Mask', 10, 100, CURRENT_TIMESTAMP);
-- item_id нарушает NOT NULL.
-- INSERT INTO inventory VALUES (3, NULL, 10, 100, CURRENT_TIMESTAMP);
-- item_name нарушает NOT NULL.
-- INSERT INTO inventory VALUES (4, 'Syringe', NULL, 100, CURRENT_TIMESTAMP);
-- quantity нарушает NOT NULL.
-- INSERT INTO inventory VALUES (5, 'Syringe', -1, 100, CURRENT_TIMESTAMP);
-- CHECK quantity >= 0.
-- INSERT INTO inventory VALUES (6, 'Tape', 10, 0, CURRENT_TIMESTAMP);
-- CHECK unit_price > 0.
-- INSERT INTO inventory VALUES (7, 'Tape', 10, 100, NULL);
-- last_updated нарушает NOT NULL.

SELECT * FROM customers;
SELECT * FROM inventory;


-- ============================================================
-- PART 3. UNIQUE CONSTRAINTS
-- ============================================================

-- Task 3.1 и 3.3. Именованные ограничения уникальности.
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    user_id INTEGER,
    username TEXT CONSTRAINT unique_username UNIQUE,
    email TEXT CONSTRAINT unique_email UNIQUE,
    created_at TIMESTAMP
);

INSERT INTO users VALUES
(1, 'ivan', 'ivan@example.com', TIMESTAMP '2026-09-01 10:00:00'),
(2, 'anna', 'anna@example.com', TIMESTAMP '2026-09-02 11:00:00');

-- Ошибки для проверки (по одной):
-- INSERT INTO users VALUES (3, 'ivan', 'ivan3@example.com', CURRENT_TIMESTAMP);
-- unique_username: имя ivan уже существует.
-- INSERT INTO users VALUES (4, 'petr', 'ivan@example.com', CURRENT_TIMESTAMP);
-- unique_email: адрес ivan@example.com уже существует.

-- Task 3.2. Составное UNIQUE.
DROP TABLE IF EXISTS course_enrollments CASCADE;
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_student_course_semester
        UNIQUE (student_id, course_code, semester)
);

INSERT INTO course_enrollments VALUES
(1, 101, 'CS101', 'Fall 2026'),
(2, 101, 'DB201', 'Fall 2026'),
(3, 102, 'CS101', 'Fall 2026');

-- Ошибка для проверки:
-- INSERT INTO course_enrollments VALUES (4, 101, 'CS101', 'Fall 2026');
-- unique_student_course_semester: такая комбинация уже существует.

SELECT * FROM users;
SELECT * FROM course_enrollments;


-- ============================================================
-- PART 4. PRIMARY KEY CONSTRAINTS
-- ============================================================

-- Task 4.1. Первичный ключ отдела.
DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES
(10, 'IT', 'Taraz'),
(20, 'HR', 'Almaty'),
(30, 'Finance', 'Astana');

-- Ошибки для проверки (по одной):
-- INSERT INTO departments VALUES (10, 'Duplicate department', 'Taraz');
-- PRIMARY KEY: dept_id=10 уже существует.
-- INSERT INTO departments VALUES (NULL, 'Unknown', 'Taraz');
-- PRIMARY KEY не допускает NULL.

-- Task 4.2. Составной первичный ключ.
DROP TABLE IF EXISTS student_courses CASCADE;
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES
(101, 1, DATE '2026-09-01', 'A'),
(101, 2, DATE '2026-09-02', 'B'),
(102, 1, DATE '2026-09-03', 'A');

-- Ошибка для проверки:
-- INSERT INTO student_courses VALUES (101, 1, DATE '2026-09-10', 'C');
-- Составной PRIMARY KEY: пара (101, 1) уже существует.

-- Task 4.3. Краткое сравнение:
-- UNIQUE: запрещает повторения значений (или комбинаций), обычно допускает NULL
-- в PostgreSQL по умолчанию; в одном столбце/наборе столбцов может быть несколько
-- UNIQUE-ограничений.
-- PRIMARY KEY: уникально идентифицирует строку, запрещает дубликаты и NULL.
-- В таблице может быть только один PRIMARY KEY (в том числе составной), потому
-- что он определяет единственный основной идентификатор строки. UNIQUE может быть
-- несколько, так как альтернативных уникальных признаков может быть несколько.
-- Один столбец PRIMARY KEY удобен, когда достаточно одного идентификатора.
-- Составной PRIMARY KEY подходит, когда уникальность определяется комбинацией,
-- например student_id + course_id.

SELECT * FROM departments;
SELECT * FROM student_courses;


-- ============================================================
-- PART 5. FOREIGN KEY CONSTRAINTS
-- ============================================================

-- Task 5.1. Внешний ключ сотрудника на отдел.
DROP TABLE IF EXISTS employees_dept CASCADE;
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES
(1, 'Ivan', 10, DATE '2025-02-01'),
(2, 'Anna', 20, DATE '2024-06-15');

-- Ошибка для проверки:
-- INSERT INTO employees_dept VALUES (3, 'Petr', 999, DATE '2026-01-01');
-- FOREIGN KEY: отдела 999 нет в departments.

-- Task 5.2. Схема библиотеки: сначала родительские таблицы.
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES
(1, 'Abai Qunanbaiuly', 'Kazakhstan'),
(2, 'Mukhtar Auezov', 'Kazakhstan'),
(3, 'Chingiz Aitmatov', 'Kyrgyzstan'),
(4, 'Jane Austen', 'United Kingdom'),
(5, 'George Orwell', 'United Kingdom');

INSERT INTO publishers VALUES
(1, 'Mektep', 'Almaty'),
(2, 'Atamura', 'Almaty'),
(3, 'Oxford University Press', 'Oxford'),
(4, 'Penguin Classics', 'London'),
(5, 'Kyrgyzstan Publishing', 'Bishkek');

INSERT INTO books VALUES
(1, 'Words of Edification', 1, 1, 1890, '9780000000001'),
(2, 'The Path of Abai', 2, 2, 1942, '9780000000002'),
(3, 'The Day Lasts More Than a Hundred Years', 3, 5, 1980, '9780000000003'),
(4, 'Pride and Prejudice', 4, 4, 1813, '9780000000004'),
(5, 'Animal Farm', 5, 3, 1945, '9780000000005');

-- Ошибки для проверки:
-- INSERT INTO books VALUES (6, 'Unknown Author', 999, 1, 2020, '9780000000006');
-- FOREIGN KEY: автора 999 нет в authors.
-- INSERT INTO books VALUES (7, 'Unknown Publisher', 1, 999, 2020, '9780000000007');
-- FOREIGN KEY: издателя 999 нет в publishers.
-- INSERT INTO books VALUES (8, 'Duplicate ISBN', 1, 1, 2020, '9780000000001');
-- UNIQUE: ISBN уже существует.

SELECT * FROM authors;
SELECT * FROM publishers;
SELECT * FROM books;

-- Task 5.3. ON DELETE RESTRICT и CASCADE.
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS products_fk CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'Electronics'), (2, 'Books');
INSERT INTO products_fk VALUES
(1, 'Keyboard', 1),
(2, 'SQL textbook', 2);
INSERT INTO orders VALUES
(100, DATE '2026-10-01'),
(101, DATE '2026-10-02');
INSERT INTO order_items VALUES
(1, 100, 1, 2),
(2, 100, 2, 1),
(3, 101, 1, 1);

-- Тест RESTRICT (ожидается ошибка, если раскомментировать):
-- DELETE FROM categories WHERE category_id = 1;
-- RESTRICT запрещает удаление категории, пока на неё ссылается products_fk.

-- Тест CASCADE:
-- До удаления: SELECT * FROM order_items WHERE order_id = 100;
-- DELETE FROM orders WHERE order_id = 100;
-- После удаления: SELECT * FROM order_items WHERE order_id = 100;
-- Все строки order_items для order_id=100 удаляются автоматически (CASCADE).

SELECT * FROM categories;
SELECT * FROM products_fk;
SELECT * FROM orders;
SELECT * FROM order_items;


-- ============================================================
-- PART 6. PRACTICAL APPLICATION: E-COMMERCE DATABASE
-- ============================================================

-- Удаляем дочерние таблицы раньше родительских.
DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL
        REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (
        status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')
    )
);

CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL
        REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL
        REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0)
);

-- Не менее 5 записей в каждой таблице.
INSERT INTO customers VALUES
(1, 'Ivan Petrov', 'ivan@example.com', '+77010000001', DATE '2026-09-01'),
(2, 'Anna Sidorova', 'anna@example.com', '+77010000002', DATE '2026-09-03'),
(3, 'Petr Smirnov', 'petr@example.com', NULL, DATE '2026-09-05'),
(4, 'Maria Ivanova', 'maria@example.com', '+77010000004', DATE '2026-09-07'),
(5, 'Ali Nur', 'ali@example.com', '+77010000005', DATE '2026-09-09');

INSERT INTO products VALUES
(1, 'Keyboard', 'Mechanical keyboard', 15000.00, 20),
(2, 'Mouse', 'Wireless mouse', 8000.00, 35),
(3, 'Monitor', '27-inch monitor', 85000.00, 10),
(4, 'USB cable', 'USB-C cable', 2500.00, 100),
(5, 'Headphones', 'Over-ear headphones', 22000.00, 15);

INSERT INTO orders VALUES
(100, 1, DATE '2026-10-01', 23000.00, 'pending'),
(101, 2, DATE '2026-10-02', 85000.00, 'processing'),
(102, 3, DATE '2026-10-03', 2500.00, 'shipped'),
(103, 4, DATE '2026-10-04', 22000.00, 'delivered'),
(104, 5, DATE '2026-10-05', 15000.00, 'cancelled');

INSERT INTO order_details VALUES
(1, 100, 1, 1, 15000.00),
(2, 100, 2, 1, 8000.00),
(3, 101, 3, 1, 85000.00),
(4, 102, 4, 1, 2500.00),
(5, 103, 5, 1, 22000.00);

-- Проверочные запросы: количество строк (ожидается по 5 в каждой таблице).
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details;

-- Просмотр заказов с клиентами.
SELECT o.order_id, c.name AS customer_name, o.order_date,
       o.total_amount, o.status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Проверка суммы деталей заказа (сравнить с total_amount).
SELECT od.order_id, SUM(od.quantity * od.unit_price) AS calculated_total,
       o.total_amount
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY od.order_id, o.total_amount
ORDER BY od.order_id;

-- Некорректные тесты ниже закомментированы: включайте по одному,
-- чтобы скрипт продолжал выполняться до следующих запросов.
-- UNIQUE email:
-- INSERT INTO customers VALUES (6, 'Duplicate email', 'ivan@example.com', NULL, CURRENT_DATE);
-- CHECK price >= 0:
-- INSERT INTO products VALUES (6, 'Bad price', 'Negative price', -1, 5);
-- CHECK stock_quantity >= 0:
-- INSERT INTO products VALUES (7, 'Bad stock', 'Negative stock', 100, -1);
-- CHECK status:
-- INSERT INTO orders VALUES (105, 1, CURRENT_DATE, 100, 'unknown');
-- FOREIGN KEY customer_id:
-- INSERT INTO orders VALUES (106, 999, CURRENT_DATE, 100, 'pending');
-- CHECK quantity > 0:
-- INSERT INTO order_details VALUES (6, 100, 1, 0, 15000);
-- FOREIGN KEY product_id:
-- INSERT INTO order_details VALUES (7, 100, 999, 1, 100);

-- ON DELETE behavior:
-- DELETE FROM customers WHERE customer_id = 1;
-- Ожидается отказ RESTRICT, если у клиента есть заказ.
-- DELETE FROM orders WHERE order_id = 100;
-- Удаление заказа автоматически удалит его order_details (CASCADE).

-- Итог: все основные ограничения проверены примерами корректных данных
-- и закомментированными запросами, которые при запуске по одному должны
-- выдавать ошибки для демонстрации работы ограничений.
