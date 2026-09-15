# Database Systems Laboratory Work

## Week 2: Relational Model & Keys

Student: Makhmud Tursynbai  
Group: Wednesday 17:00-18:00  
Instructor: Aibek T. Kuralbaev  
Date: September 15, 2026

---

# Part 1: Key Identification Exercises

## Task 1.1: Superkey and Candidate Key Analysis

### Relation A: Employee

Employee(EmpID, SSN, Email, Phone, Name, Department, Salary)

### 1. Superkeys

At least 6 superkeys are:

1. {EmpID}
2. {SSN}
3. {Email}
4. {Phone}
5. {EmpID, SSN}
6. {EmpID, Email}

### 2. Candidate Keys

The candidate keys are:

- EmpID
- SSN
- Email
- Phone

These attributes can uniquely identify an employee and are minimal superkeys.

### 3. Primary Key

I choose EmpID as the primary key.

Reason: EmpID is unique, simple, stable, and does not contain sensitive personal information. It is also convenient for referencing employees from other tables.

### 4. Can two employees have the same phone number?

Yes, two employees can have the same phone number.

The business rules do not state that Phone must be unique. For example, employees could share an office or family phone number.

---

## Relation B: Course Registration

Registration(StudentID, CourseCode, Section, Semester, Year, Grade, Credits)

### Business Rules

- A student can take the same course in different semesters.
- A student cannot register for the same course section in the same semester.
- Each course section in a semester has a fixed credit value.

### 1. Primary Key

The minimum attributes needed for the primary key are:

(StudentID, CourseCode, Section, Semester, Year)

### 2. Why each attribute is necessary

| Attribute | Reason |
|---|---|
| StudentID | Identifies the student |
| CourseCode | Identifies the course |
| Section | Identifies the particular course section |
| Semester | Distinguishes different semesters |
| Year | Distinguishes the same semester in different years |

Therefore:

Primary Key = (StudentID, CourseCode, Section, Semester, Year)

### 3. Additional Candidate Keys

No additional candidate keys can be determined from the given information.

---

# Task 1.2: Foreign Key Design

## Foreign Key Relationships

| Table | Foreign Key | References |
|---|---|---|
| Student | AdvisorID | Professor(ProfID) |
| Course | DepartmentCode | Department(DeptCode) |
| Department | ChairID | Professor(ProfID) |
| Enrollment | StudentID | Student(StudentID) |
| Enrollment | CourseID | Course(CourseID) |
