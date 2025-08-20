-- University Course Management System (Final Project)

USE rw7;

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    BirthDate DATE,
    EnrollmentDate DATE
);

-- Create Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert sample data (Departments)
INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Mathematics'),
(3,'Physics'),
(4,'Information Technology'),
(5,'Biology'),
(6,'Chemistry'),
(7,'English'),
(8,'Business');

-- Insert sample data (Students)
INSERT INTO Students VALUES
(1,'John','Doe','john.doe@univ.com','2000-01-15','2022-08-01'),
(2,'Jane','Smith','jane.smith@univ.com','1999-05-25','2021-08-01'),
(3,'Michael','Brown','michael.brown@univ.com','2001-02-14','2023-01-15'),
(4,'Emily','Davis','emily.davis@univ.com','2000-10-02','2022-02-10'),
(5,'Daniel','Miller','daniel.miller@univ.com','1998-11-10','2019-07-01'),
(6,'Olivia','Wilson','olivia.wilson@univ.com','1999-09-09','2020-09-05'),
(7,'William','Taylor','william.taylor@univ.com','2001-12-22','2023-02-01'),
(8,'Emma','Anderson','emma.anderson@univ.com','2000-03-30','2022-03-15');

-- Insert sample data (Courses)
INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Data Structures',2,4),
(103,'Operating Systems',1,4),
(104,'Linear Algebra',2,3),
(105,'Networking',1,3),
(106,'Database Design',1,4),
(107,'Statistics',2,3),
(108,'Web Technologies',1,3);

-- Insert sample data (Instructors)
INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice.johnson@univ.com',1),
(2,'Bob','Lee','bob.lee@univ.com',2),
(3,'Mark','Allen','mark.allen@univ.com',1),
(4,'Susan','Hill','susan.hill@univ.com',2),
(5,'David','Green','david.green@univ.com',1),
(6,'Laura','King','laura.king@univ.com',3),
(7,'Robert','Young','robert.young@univ.com',2),
(8,'Grace','White','grace.white@univ.com',1);

-- Insert sample data (Enrollments)
INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,1,102,'2022-08-01'),
(3,2,102,'2021-08-01'),
(4,3,101,'2023-01-15'),
(5,4,103,'2022-02-10'),
(6,5,104,'2019-07-01'),
(7,6,105,'2020-09-05'),
(8,7,101,'2023-02-01');

-- Queries to Perform

-- 1. CRUD Operations (example)
INSERT INTO Students VALUES (9,'Henry','Moore','henry.moore@univ.com','2000-06-12','2023-03-15');
UPDATE Students SET Email='john.updated@univ.com' WHERE StudentID=1;
DELETE FROM Students WHERE StudentID=9;
SELECT * FROM Students;

-- 2. Retrieve students who enrolled after 2022
SELECT * FROM Students WHERE YEAR(EnrollmentDate) > 2022;

-- 3. Retrieve courses offered by the Mathematics department with a limit of 5
SELECT * FROM Courses WHERE DepartmentID=2 LIMIT 5;

-- 4. Get the number of students enrolled in each course (more than 5)
SELECT CourseID, COUNT(*) AS StudentCount
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(*) > 5;

-- 5. Find students who are enrolled in both Intro to SQL and Data Structures
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID=101)
AND s.StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID=102);

-- 6. Find students who are either enrolled in Intro to SQL or Data Structures
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID=101)
OR s.StudentID IN (SELECT StudentID FROM Enrollments WHERE CourseID=102);

-- 7. Calculate average credits for all courses
SELECT AVG(Credits) AS AvgCredits FROM Courses;

-- 8. Find the maximum salary of instructors in the Computer Science department
SELECT MAX(Salary) FROM Instructors WHERE DepartmentID=1;

-- 9. Count the number of students enrolled in each department
SELECT d.DepartmentName, COUNT(s.StudentID) AS TotalStudents
FROM Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentName;

-- 10. INNER JOIN: Retrieve students and their corresponding courses
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN: Retrieve all students and their corresponding courses (if any).
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. Subquery: Find students enrolled in courses that have more than 10 students.
SELECT * FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Enrollments
    WHERE CourseID IN (
        SELECT CourseID FROM Enrollments GROUP BY CourseID HAVING COUNT(*)>10
    )
);

-- 13. Extract the year from the EnrollmentDate of students.
SELECT StudentID, YEAR(EnrollmentDate) AS EnrollmentYear FROM Students;

-- 14. Concatenate the instructor's first and last name.
SELECT CONCAT(FirstName,' ',LastName) AS FullName FROM Instructors;
