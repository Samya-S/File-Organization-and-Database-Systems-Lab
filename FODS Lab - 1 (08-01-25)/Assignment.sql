create table p (a int, b int);
insert into p values (2,7),(5,9),(7,3);
select * from p;
-- When execute second time drop table p is needed
drop table p;

-- Example 2:
drop table p;
create table p (a int,b int,c int);
insert into p values (2,7,1),(5,9,4),(7,3,6),(2,8,1);
select distinct a,c from p where b>5; --output (2,1)(5,4) when distinct removed (2,1)(5,4)(2,1)

-- Example 3:
create table P (a int, b int);
create table Q (b int, c int);
insert into P values (2,7),(5,9),(7,3),(2,9);
insert into Q values (7,8),(5,9),(7,3),(9,4);
select b from P where a in (2,5); -- 7,9,9
select c from Q where b in (select b from P where a=2); -- it finds all c's corresponding to a=2.


-- Hari has roll no 13 and department MA.
-- Kapil has roll no 24 and department PH.
-- Ravi has roll no 13 and department PH.
-- Here entity is Student. Its attributes are roll no, department, name. [Student;name,roll no,department]
-- Key of student is roll no, department. Because two students in same department can not have same roll no.
-- Another key is name provided two students do not have same name. [Student;name,roll no,department;Key name, roll no + department]
-- Hari is enrolled in LA,FODS.
-- Kapil is enrolled in CN,LA
-- Ravi is enrolled in OS.
-- Another entity is course. Its attribute is name [Course;name;key name]   
-- A relation enroll is between course and student. [Student]---(Enroll)----[Course]
-- Corresponding to every entity and relation there is a table.
-- Student: (Hari,13,MA)(Kapil,24,PH)(Ravi,13,PH)
-- Course: Not needed
-- Enroll: (Hari,LA)(Hari,FODS)(Kapil,CN)(Kapil,LA)(Ravi,OS)
-- Hari has got 74 marks in LA and 47 in FODS.
-- Kapil has got 32 marks in CN and 94 in LA,
-- Ravi is has got 67 marks in OS.
-- Now Enroll has attribute marks. Hence Enroll table is modified as following.
-- Enroll: (Hari,LA,74)(Hari,FODS,47)(Kapil,CN,32)(Kapil,LA,94)(Ravi,OS,67) Key:student name+course
-- Enroll table can also be: (13,MA,LA,74)(13,MA,FODS,47)(24,PH,CN,32)(24,PH,LA,94)(13,PH,OS,67) Key:roll no+dept+course
-- Corresponding to every entity a table is made. A tuple has values of all attributes of that entity.
-- A relation between entities is represented by taking any key values from both entities.
-- Let teacher of LA is Anil, FODS is Dipu, CN is Gyan, OS is Lalit. Hence a table of course is also made.
-- Course: (LA,Anil)(FODS,Dipu)(CN,Gyan)(OS,Lalit)
-- ER Diagram: [Student;name,roll no,dept;Key:name,roll no+dept]---(Enroll;marks)----[Course;name,teacher;Key:name]

-- In single table
-- (Hari,13,MA,LA,Anil,74)(Hari,13,MA,FODS,Dipu,47)(Kapil,24,PH,CN,Gyan,32)(Kapil,24,PH,LA,Anil,94)(Ravi,13,PH,OS,Lalit,67)
-- Single table has attributes student name, roll no, department, course name, teacher name, marks.
-- Key of the single table is roll no, department, course name or student name, course name

-- In multiple tables
-- Student: (Hari,13,MA)(Kapil,24,PH)(Ravi,13,PH)
-- Course: (LA,Anil)(FODS,Dipu)(CN,Gyan)(OS,Lalit)
-- Enroll: (13,MA,LA,74)(13,MA,FODS,47)(24,PH,CN,32)(24,PH,LA,94)(13,PH,OS,67)

create table p (name char(10), subject char (4) );
insert into p values ('Hari','LA'),('Hari','FODS'),('Kapil','CN'),('Kapil','LA'),('Ravi','OS');
select * from p;

-- Write sql query for following in single table and multiple tables.
-- 1: Write sql query  to find names of students who are enrolled in LA and FODS.
-- Answer: select name from p where subject in ('LA','FODS');
-- 2: Find marks of Hari in FODS.
-- 3: Find all marks given by Anil.
-- 4: Find teachers of roll no 13.

-- Solution:

-- Single table
create table Student (Name char(10), Roll int, Department char(2), Course char(4), Teacher char(10), Marks int);
insert into Student values ("Hari",13,"MA","LA","Anil",74), ("Hari",13,"MA","FODS","Dipu",47), ("Kapil",24,"PH","CN","Gyan",32), ("Kapil",24,"PH","LA","Anil",94), ("Ravi",13,"PH","OS","Lalit",67);

select distinct Name from Student where course in ("LA", "FODS");
select Marks from Student where Name is "Hari" and Course is "FODS";
select Marks from Student where Teacher is "Anil";
select Teacher from Student where Roll is 13;

drop table Student;


-- Multiple tables (with Enroll table having name)
create table Student (Name char(10), Roll int, Department char(2));
insert into Student values ("Hari", 13, "MA"), ("Kapil", 24, "PH"), ("Ravi", 13, "PH");
--select * from Student;

create table Enroll (Name char(10), Course char(4), Marks int);
insert into Enroll values ("Hari", "LA", 74), ("Hari", "FODS", 47), ("Kapil", "CN", 32), ("Kapil", "LA", 94), ("Ravi", "OS", 67);
--select * from Enroll;

create table Course (Course char(4), Name char(10));
insert into Course values ("LA", "Anil"), ("FODS", "Dipu"), ("CN", "Gyan"), ("OS", "Lalit");
--select * from Course;

select distinct Name from Enroll where Course in ("LA", "FODS");

select Marks from Enroll where Name is "Hari" and Course is "FODS";

select Marks from Enroll where Course in (select Course from Course where Name is "Anil");

select Name from Course where Course in (select Course from Enroll where Name in (select Name from Student where Roll is 13));

drop table Student;
drop table Enroll;
drop table Course;


-- Multiple tables (with Enroll table having roll no and department)
create table Student (Name char(10), Roll int, Department char(2));
insert into Student values ("Hari", 13, "MA"), ("Kapil", 24, "PH"), ("Ravi", 13, "PH");
--select * from Student;

create table Enroll (Roll int, Department char(2), Course char(4), Marks int);
insert into Enroll values (13, "MA", "LA", 74), (13, "MA", "FODS", 47), (24, "PH", "CN", 32), (24, "PH", "LA", 94), (13, "PH", "OS", 67);
--select * from Enroll;

create table Course (Course char(4), Name char(10));
insert into Course values ("LA", "Anil"), ("FODS", "Dipu"), ("CN", "Gyan"), ("OS", "Lalit");
--select * from Course;

select Name from Student where (Roll, Department) in (select distinct Roll, Department from Enroll where Course in ("LA", "FODS"));

select Marks from Enroll where Course in ("FODS") and (Roll, Department) in (select distinct Roll, Department from Student where Name is "Hari");

select Marks from Enroll where Course in (select Course from Course where Name is "Anil");

select Name from Course where Course in (select Course from Enroll where Roll is 13);

drop table Student;
drop table Enroll;
drop table Course;