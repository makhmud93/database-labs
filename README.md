Business rules given:
Each student has exactly one major.
Each course has a fixed name.
Each instructor has exactly one name.
Rooms are unique across campus, so a room determines its building.
Each course section is taught by one instructor, at one time, in one room.
A student can be enrolled in multiple course sections.
1. Primary key — why it's tricky
The primary key is:
(StudentID, CourseID)
This is tricky because no single attribute can serve as the key: StudentID alone repeats (a student takes many courses), and CourseID alone also repeats (a course has many students). Only the combination uniquely identifies "this student is enrolled in this course section." At the same time, most of the other attributes (InstructorID, TimeSlot, Room, Building) don't actually depend on the combination — they depend only on CourseID, which is what causes the normalization problems below.
2. Functional dependencies
StudentID   → StudentMajor
CourseID    → CourseName, InstructorID, TimeSlot, Room
InstructorID → InstructorName
Room        → Building
3. Is the table in BCNF?
A table is in BCNF only if, for every functional dependency X → Y, X is a superkey. Checking each FD against the key (StudentID, CourseID):
FD
Is left side a superkey?
BCNF?
StudentID → StudentMajor
No
❌ Violation
CourseID → CourseName, InstructorID, TimeSlot, Room
No
❌ Violation
InstructorID → InstructorName
No
❌ Violation
Room → Building
No
❌ Violation
The table is NOT in BCNF — it has multiple violations.
4. Step-by-step BCNF decomposition
Step 1 — split off StudentID → StudentMajor:
Student(StudentID, StudentMajor) — PK: StudentID
Remaining: CourseScheduleR1(StudentID, CourseID, CourseName, InstructorID, InstructorName, TimeSlot, Room, Building)
Step 2 — split off CourseID → CourseName, InstructorID, TimeSlot, Room:
Course(CourseID, CourseName, InstructorID, TimeSlot, Room) — PK: CourseID
Remaining: Enrollment(StudentID, CourseID) — PK: (StudentID, CourseID)
Step 3 — inside Course, split off InstructorID → InstructorName:
Instructor(InstructorID, InstructorName) — PK: InstructorID
Course becomes: Course(CourseID, CourseName, InstructorID, TimeSlot, Room)
Step 4 — inside Course, split off Room → Building:
RoomTable(Room, Building) — PK: Room
Course becomes: Course(CourseID, CourseName, InstructorID, TimeSlot, Room)
Final BCNF schemas:
Table
Attributes
Primary Key
Foreign Keys
Student
StudentID, StudentMajor
StudentID
—
Instructor
InstructorID, InstructorName
InstructorID
—
RoomTable
Room, Building
Room
—
Course
CourseID, CourseName, InstructorID, TimeSlot, Room
CourseID
InstructorID → Instructor.InstructorID, Room → RoomTable.Room
Enrollment
StudentID, CourseID
(StudentID, CourseID)
StudentID → Student.StudentID, CourseID → Course.CourseID
5. Possible loss of information
The decomposition is a lossless join — each split was made on a functional dependency where the determinant stays as the primary key in one of the resulting tables, so joining everything back together reproduces the original data exactly with no extra or missing rows.
However, it is not fully dependency-preserving. In the original table, a rule like "a room cannot host two different courses at the same time slot" could be checked directly within one table. After decomposition, that same rule now requires joining Course with itself (comparing rows that share the same Room and TimeSlot), since TimeSlot and Room no longer live next to CourseID in a way that lets a simple key constraint catch a scheduling conflict.
Part 5: Design Challenge
Task 5.1 — Real-World Application: Student Clubs
Entities, attributes, relationships, cardinalities
Entity
Description
Student
A university student who can join clubs and attend events.
Club
A student organization (name, description, founding date).
Advisor
A faculty member who oversees one or more clubs.
Membership
Associative entity resolving the M:N relationship between Student and Club, storing the join date.
OfficerPosition
Records a student holding an officer role (e.g. President, Treasurer) in a club for a specific term.
Event
