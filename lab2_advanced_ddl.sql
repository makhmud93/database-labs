
-- Task 1: Создание таблицы courses
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL
        CHECK (credits BETWEEN 1 AND 6),
    prerequisite_id INTEGER,
    CONSTRAINT fk_prerequisite
        FOREIGN KEY (prerequisite_id)
        REFERENCES courses(course_id)
);
-- Task 2: Создание таблицы enrollments
CREATE TABLE enrollments (
    student_id INTEGER,
    course_id INTEGER
        REFERENCES courses(course_id)
        ON DELETE CASCADE,
    seat_no INTEGER NOT NULL
        CHECK (seat_no > 0),
    grade TEXT,
    CONSTRAINT valid_grade
        CHECK (grade IN ('A', 'B', 'C', 'D', 'F')
               OR grade IS NULL),
    PRIMARY KEY (student_id, course_id),
    UNIQUE (course_id, seat_no)
);
Task 3. Правильные ответы
Согласно таблицам и порядку выполнения операций на странице 1 PDF:
№ Ответ Объяснение
A OK Код курса уникален, кредиты равны 6 — допустимо.
B Ошибка: foreign key prerequisite_id = 6, но курса с course_id = 6 нет.
C Ошибка: UNIQUE Места станут 2, 3, 4. Для курса 3 место 2 уже занято студентом 1002.
D Ошибка: NOT NULL Нельзя добавить столбец teacher TEXT NOT NULL без значения по умолчанию в непустую таблицу.
E Ошибка: foreign key Нельзя удалить курс 2, поскольку курс 3 ссылается на него через prerequisite_id.
F OK Курс 3 удаляется, связанные записи в enrollments удаляются благодаря ON DELETE CASCADE.
Важный нюанс для Task C
PostgreSQL проверяет ограничение уникальности для обновляемых строк. При выполнении одного UPDATE с увеличением всех мест на 1 возможен конфликт с ещё не обновлённой строкой — поэтому операция может завершиться ошибкой UNIQUE.
Итог для листа ответов:
A — OK
B — Foreign key violation
C — Unique constraint violation
D — NOT NULL violation
E — Foreign key violation
F — OK
