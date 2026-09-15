Database Systems Laboratory Work
Week 2: Relational Model & Keys
Student: __________ Group: __________ Date: __________
Table of Contents
Part 1: Key Identification Exercises
Part 2: ER Diagram Construction
Part 4: Normalization Workshop
Part 5: Design Challenge
Conclusion
Part 1: Key Identification Exercises
Task 1.1 — Superkey and Candidate Key Analysis
Relation A: Employee
SQL


Employee(EmpID, SSN, Email, Phone, Name, Department, Salary)
Sample Data
EmpID
SSN
Email
Phone
Name
Department
Salary
101
123-45-6789
john@company.com
555-0101
John
IT
75000
102
987-65-4321
mary@company.com
555-0102
Mary
HR
68000
103
456-78-9123
bob@company.com
555-0103
Bob
IT
72000
1. At least 6 superkeys
A superkey is any set of attributes that uniquely identifies a row, so a candidate key plus any extra attribute still counts as a superkey.
#
Superkey
1
{EmpID}
2
{SSN}
3
{Email}
4
{EmpID, SSN}
5
{EmpID, Name}
6
{EmpID, Department}
7
{SSN, Salary}
8
{EmpID, SSN, Email, Phone, Name, Department, Salary}
2. Candidate keys
{EmpID}
{SSN}
{Email}
Each of these attributes is guaranteed unique per employee on its own, and none of them can be reduced further (they are single attributes), so each qualifies as a minimal superkey — a candidate key.
Phone, Name, Department, and Salary are not candidate keys because they are not guaranteed to be unique across all employees.
3. Primary key choice
Chosen primary key: EmpID
Reasoning:
It is a system-generated identifier, so it never changes over an employee's career (unlike Email, which can change if a person's name changes).
It avoids storing a sensitive value (SSN) as the main lookup key, which is safer from a privacy standpoint.
It is short and simple to index compared to Email.
4. Can two employees have the same phone number?
Looking at the sample data, all three phone numbers are different. However, Phone was not identified as a candidate key, so nothing in the schema stops two employees from sharing a phone number. In practice this could easily happen — for example, two employees sharing a department extension or working the same desk on different shifts. So yes, based on the schema (not the specific sample), duplicate phone numbers are allowed unless a business rule or a UNIQUE constraint is added.
Relation B: Course Registration
копировать


Registration(StudentID, CourseCode, Section, Semester, Year, Grade, Credits)
Business rules given:
A student can take the same course in different semesters.
A student cannot register for the same course section in the same semester.
Each course section in a semester has a fixed credit value.
1. Minimum attributes needed for the primary key
копировать


Primary Key = {StudentID, CourseCode, Section, Semester, Year}
2. Why each attribute is necessary
Attribute
Why it's needed in the key
StudentID
Identifies which student the registration record belongs to.
CourseCode
Identifies which course was taken.
Section
A course can have multiple sections running at once; the section separates them.
Semester
Distinguishes registrations across the academic calendar (e.g. Fall vs Spring).
Year
Semester alone repeats every year (there is a "Fall" every year), so Year is required to tell Fall 2024 apart from Fall 2025. Without it, the rule "cannot register for the same section in the same semester" could not actually be enforced.
Grade and Credits are not part of the key — they simply describe the outcome of a registration and don't help identify the row.
3. Additional candidate keys
No other candidate key exists among the given attributes. There is no other combination of columns that would uniquely identify a registration row without also including StudentID, CourseCode, Section, Semester, and Year — this combination is the only natural key available (unless a surrogate RegistrationID were introduced, which is not part of the given schema).
Task 1.2 — Foreign Key Design
Given tables:
SQL


Student(StudentID, Name, Email, Major, AdvisorID)
Professor(ProfID, Name, Department, Salary)
Course(CourseID, Title, Credits, DepartmentCode)
Department(DeptCode, DeptName, Budget, ChairID)
Enrollment(StudentID, CourseID, Semester, Grade)
Foreign key relationships:
Foreign Key
→
Referenced Primary Key
Student.AdvisorID
→
Professor.ProfID
Course.DepartmentCode
→
Department.DeptCode
Department.ChairID
→
Professor.ProfID
Enrollment.StudentID
→
Student.StudentID
Enrollment.CourseID
→
Course.CourseID
Note / assumption: Professor.Department is left as a plain text attribute rather than a foreign key, since its name doesn't match Department.DeptCode and the task doesn't state that professors are formally linked to the Department table. If a stricter design were required, this column could be renamed and turned into a sixth foreign key (Professor.DeptCode → Department.DeptCode).
Part 2: ER Diagram Construction
Task 2.1 — Hospital Management System
Entities
Entity
Type
Reason
Patient
Strong
Has its own unique PatientID, exists independently.
Doctor
Strong
Has its own unique DoctorID, exists independently.
Department
Strong
Has its own unique department code.
Room
Weak
Room numbers repeat across departments (Room 101 in Cardiology ≠ Room 101 in Neurology), so a room cannot be uniquely identified without also knowing its owning department.
Appointment
Strong (associative)
Has its own AppointmentID and connects a Patient and a Doctor.
Prescription
Strong (associative)
Has its own PrescriptionID and connects a Doctor and a Patient.
Attributes
Entity
Attribute
Type
Patient
PatientID
Simple (key)
Patient
Name
Composite (First, Last)
Patient
Birthdate
Simple
Patient
Address
Composite (Street, City, State, Zip)
Patient
Phone
Multivalued (multiple numbers allowed)
Patient
InsuranceInfo
Composite (Provider, Policy Number)
Doctor
DoctorID
Simple (key)
Doctor
Name
Composite
Doctor
Specialization
Multivalued (a doctor can have more than one)
Doctor
Phone
Simple
Doctor
OfficeLocation
Simple
Department
DeptCode
Simple (key)
Department
Name
Simple
Department
Location
Simple
Room
RoomNumber
Simple (partial key)
Appointment
AppointmentID
Simple (key)
Appointment
DateTime
Simple
Appointment
Purpose
Simple
Appointment
Notes
Simple
Prescription
PrescriptionID
Simple (key)
Prescription
Medication
Simple
Prescription
Dosage
Simple
Prescription
Instructions
Simple
Relationships & cardinalities
Relationship
Cardinality
Patient — has — Appointment
1:N
Doctor — conducts — Appointment
1:N
Doctor — writes — Prescription
1:N
Patient — receives — Prescription
1:N
Department — has — Room (identifying relationship)
1:N
Doctor — works in — Department (assumption: each doctor belongs to one department)
1:N
Primary keys: PatientID, DoctorID, DeptCode, AppointmentID, PrescriptionID, and for the weak entity Room the key is the composite (DeptCode, RoomNumber).
Figure 1. Hospital Management System ER Diagram
Task 2.2 — E-commerce Platform
Entities, attributes, and primary keys
Entity
Key Attribute(s)
Other Attributes
Customer
CustomerID (PK)
Name, Email, BillingAddress
Order
OrderID (PK)
OrderDate, Status, ShippingAddress, CustomerID (FK)
Product
ProductID (PK)
Name, Price, Description, CategoryID (FK), VendorID (FK)
Category
CategoryID (PK)
CategoryName
Vendor
VendorID (PK)
VendorName, ContactInfo
OrderItem
(OrderID, ProductID) (composite PK)
Quantity, PriceAtOrder
Review
ReviewID (PK)
Rating, Comment, ReviewDate, CustomerID (FK), ProductID (FK)
Inventory
ProductID (PK/FK)
QuantityOnHand
Relationships & cardinalities
Relationship
Cardinality
Customer — places — Order
1:N
Order — contains — Product (via OrderItem)
M:N
Product — belongs to — Category
N:1
Product — supplied by — Vendor
M:N
Product — tracked in — Inventory
1:1
Customer — reviews — Product
M:N
Weak entity and justification
OrderItem is a weak entity. It has no independent identity — a line item only makes sense as part of a specific order, and it cannot exist if the owning Order is deleted. Its identifying key is the composite (OrderID, ProductID), combining the owner's key with a partial key.
Many-to-many relationship with attributes
Order and Product share a many-to-many relationship (an order can include many products, and a product can appear on many orders). This relationship carries its own attributes — Quantity and PriceAtOrder (the price at the time of purchase, which may differ from the current product price) — so it is resolved into the OrderItem associative entity described above.
Figure 2. E-commerce Platform ER Diagram
Part 4: Normalization Workshop
Task 4.1 — Denormalized Table Analysis
копировать


StudentProject(StudentID, StudentName, StudentMajor, ProjectID, ProjectTitle,
               ProjectType, SupervisorID, SupervisorName, SupervisorDept,
               Role, HoursWorked, StartDate, EndDate)
1. Functional dependencies
копировать


StudentID              → StudentName, StudentMajor
ProjectID              → ProjectTitle, ProjectType, SupervisorID
SupervisorID           → SupervisorName, SupervisorDept
StudentID, ProjectID   → Role, HoursWorked, StartDate, EndDate
2. Problems and anomalies
Redundancy: StudentName/StudentMajor repeat every time that student works on another project. ProjectTitle, ProjectType, and supervisor details repeat for every student assigned to that project. SupervisorName/SupervisorDept repeat for every project that supervisor manages.
Update anomaly: If a supervisor moves to a different department, SupervisorDept has to be updated in every row that mentions that supervisor. Missing even one row leaves the data inconsistent.
Insert anomaly: A new project cannot be recorded until at least one student is assigned to it, because project details only exist as part of a student row. The reverse is also true — a new student cannot be added until they are placed on a project.
Delete anomaly: If the only student on a project is removed from the table, all information about that project (title, type, supervisor) disappears along with the student's row.
3. First Normal Form (1NF)
All attributes hold single, atomic values — there are no repeating groups or multivalued columns in this table. The table already satisfies 1NF, so no changes are needed at this stage.
4. Second Normal Form (2NF)
Primary key: (StudentID, ProjectID) — a student can work on multiple projects and a project can have multiple students, so both attributes are needed to identify a specific assignment.
Partial dependencies:
StudentID → StudentName, StudentMajor (depends only on part of the key)
ProjectID → ProjectTitle, ProjectType, SupervisorID, SupervisorName, SupervisorDept (depends only on part of the key)
2NF decomposition:
Table
Attributes
Primary Key
Student
StudentID, StudentName, StudentMajor
StudentID
Project
ProjectID, ProjectTitle, ProjectType, SupervisorID, SupervisorName, SupervisorDept
ProjectID
Assignment
StudentID, ProjectID, Role, HoursWorked, StartDate, EndDate
(StudentID, ProjectID)
5. Third Normal Form (3NF)
Transitive dependency: Inside the new Project table, ProjectID → SupervisorID, and SupervisorID → SupervisorName, SupervisorDept. So SupervisorName and SupervisorDept depend on ProjectID only through SupervisorID — a transitive dependency that still needs to be removed.
Final 3NF decomposition:
Table
Attributes
Primary Key
Foreign Key
Student
StudentID, StudentName, StudentMajor
StudentID
—
Supervisor
SupervisorID, SupervisorName, SupervisorDept
SupervisorID
—
Project
ProjectID, ProjectTitle, ProjectType, SupervisorID
ProjectID
SupervisorID → Supervisor.SupervisorID
Assignment
StudentID, ProjectID, Role, HoursWorked, StartDate, EndDate
(StudentID, ProjectID)
StudentID → Student.StudentID, ProjectID → Project.ProjectID
Task 4.2 — Advanced Normalization (BCNF)
копировать


CourseSchedule(StudentID, StudentMajor, CourseID, CourseName,
               InstructorID, InstructorName, TimeSlot, Room, Building)
Business rules given:
Each student has exactly one major.
Each course has a fixed name.
Each instructor has exactly one name.
Rooms are unique across campus, so a room determines its building.
Each course section is taught by one instructor, at one time, in one room.
A student can be enrolled in multiple course sections.
1. Primary key — why it's tricky
The primary key is:
копировать


(StudentID, CourseID)
This is tricky because no single attribute can serve as the key: StudentID alone repeats (a student takes many courses), and CourseID alone also repeats (a course has many students). Only the combination uniquely identifies "this student is enrolled in this course section." At the same time, most of the other attributes (InstructorID, TimeSlot, Room, Building) don't actually depend on the combination — they depend only on CourseID, which is what causes the normalization problems below.
2. Functional dependencies
копировать


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
A club activity with a date, time, and description.
Attendance
Associative entity resolving the M:N relationship between Student and Event.
Room
A physical space that can be reserved for events.
RoomReservation
Links an Event to a Room for a specific time window.
Budget
A club's allocated funds for a given fiscal year.
Expense
A recorded spend against a club's budget.
Relationships & cardinalities
Relationship
Cardinality
Student — joins — Club (via Membership)
M:N
Student — holds — OfficerPosition — in — Club
M:N (with time-bound attributes)
Advisor — advises — Club
1:N
Club — hosts — Event
1:N
Student — attends — Event (via Attendance)
M:N
Event — reserved via — RoomReservation — Room
N:1
Club — has — Budget (per fiscal year)
1:N
Club — incurs — Expense
1:N
Figure 3. Student Clubs ER Diagram
Normalized relational schema
SQL


Student (
    StudentID   INT           PRIMARY KEY,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    Major       VARCHAR(50)
)

Advisor (
    AdvisorID   INT           PRIMARY KEY,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    Department  VARCHAR(50)
)

Club (
    ClubID      INT           PRIMARY KEY,
    ClubName    VARCHAR(100),
    Description TEXT,
    FoundedDate DATE,
    AdvisorID   INT           REFERENCES Advisor(AdvisorID)
)

Membership (
    StudentID   INT           REFERENCES Student(StudentID),
    ClubID      INT           REFERENCES Club(ClubID),
    JoinDate    DATE,
    PRIMARY KEY (StudentID, ClubID)
)

OfficerPosition (
    ClubID       INT          REFERENCES Club(ClubID),
    StudentID    INT          REFERENCES Student(StudentID),
    PositionTitle VARCHAR(50),
    TermStart    DATE,
    TermEnd      DATE,
    PRIMARY KEY (ClubID, PositionTitle, TermStart)
)

Room (
    RoomID      INT           PRIMARY KEY,
    Building    VARCHAR(50),
    Capacity    INT
)

Event (
    EventID     INT           PRIMARY KEY,
    ClubID      INT           REFERENCES Club(ClubID),
    EventName   VARCHAR(100),
    EventDate   DATE,
    EventTime   TIME,
    Description TEXT
)

RoomReservation (
    ReservationID INT         PRIMARY KEY,
    EventID       INT         REFERENCES Event(EventID),
    RoomID        INT         REFERENCES Room(RoomID),
    StartTime     DATETIME,
    EndTime       DATETIME
)

Attendance (
    StudentID     INT         REFERENCES Student(StudentID),
    EventID       INT         REFERENCES Event(EventID),
    CheckInTime   DATETIME,
    PRIMARY KEY (StudentID, EventID)
)

Budget (
    ClubID          INT       REFERENCES Club(ClubID),
    FiscalYear      INT,
    AllocatedAmount DECIMAL(10,2),
    PRIMARY KEY (ClubID, FiscalYear)
)

Expense (
    ExpenseID    INT          PRIMARY KEY,
    ClubID       INT          REFERENCES Club(ClubID),
    FiscalYear   INT,
    Amount       DECIMAL(10,2),
    Description  VARCHAR(200),
    ExpenseDate  DATE,
    FOREIGN KEY (ClubID, FiscalYear) REFERENCES Budget(ClubID, FiscalYear)
)
Design decision
Decision: Whether to store officer roles as a simple Role column inside the Membership table, or as a separate OfficerPosition table.
Choice made: A separate OfficerPosition table was used.
Why: Membership and officer status don't change at the same time. A student typically joins a club once (JoinDate stays fixed), but can hold different officer roles across different terms while remaining a member the whole time. Cramming this into Membership.Role would either force one role per membership (losing history) or force awkward duplicate membership rows. A separate table with its own TermStart/TermEnd cleanly tracks officer history without disturbing the membership record.
Example queries (English, not SQL)
"Find all students who are officers in the Computer Science Club."
"List all events scheduled for next week with their room reservations."
"Show the total expenses recorded against each club's budget for the current fiscal year."
Conclusion
This laboratory work walked through the core building blocks of relational database design. Working with the Employee and Registration tables made the difference between superkeys, candidate keys, and the primary key much clearer — a superkey just has to guarantee uniqueness, while a candidate key has to do so with the fewest possible attributes. Designing the university schema showed how foreign keys tie separate tables together and enforce that a reference (like a student's advisor) always points to something that actually exists.
The ER modeling tasks (Hospital, E-commerce, and Student Clubs) were useful for practicing how to translate a plain-English scenario into entities, attributes, and relationships with the correct cardinalities. The Room and OrderItem cases were good examples of weak entities — objects that can't be uniquely identified without borrowing part of their key from an owning entity.
The normalization tasks tied everything together. Breaking down StudentProject step by step through 2NF and 3NF showed how partial and transitive dependencies cause redundancy and update/insert/delete anomalies, and how splitting a table into smaller, well-defined pieces removes them. The CourseSchedule exercise pushed this further into BCNF, showing that a table can already be free of transitive dependencies and still fail BCNF if a non-key attribute (like Room or InstructorID) determines other columns.
Overall, the lab reinforced that good relational schema design isn't just about listing tables — it's about identifying the real dependencies in the data first, choosing keys that reflect them, and only then deciding how to split the data so that every non-key fact lives in exactly one place.
