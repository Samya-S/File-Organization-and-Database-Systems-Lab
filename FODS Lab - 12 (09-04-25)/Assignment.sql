-- Wait die: When a younger job needs a resource held by older then younger commits suicide.
-- When an older job needs a resource held by younger then older waits.
-- Let A and B be jobs and R,S,T be resources.
-- Job A: run(10) need(R)  run(10)  need(S) run(10)
-- Job B: run(15) need(S)  run(10)  need(R) run(8) 
-- Let job A is older
-- A runs t=0-10. At t=10 it takes R and runs t=10-20. 
-- B runs t=0-15. At t=15 it takes S and runs t=15-25.
-- A needs S at t=20. It is already with B hence waits.
-- At t=25 job B needs R which is with A (older) hence suicides and frees resource S.
-- Job A gets S at t=25 and runs t=25-35.  Job A has to wait 20-25.
-- Let job B is older
-- A runs t=0-10. At t=10 it takes R and runs t=10-20.
-- B runs t=0-15. At t=15 it takes S and runs t=15-25.
-- A needs S at t=20. It is with B (older) hence suicides and frees R.
-- At t=25 job B needs R which is free. Hence runs 25-33. No wait in this case.
-- 
-- Wound Wait: When a younger job needs a resource held by older then younger waits.
-- When an older job needs a resource held by younger then older kill younger.
-- Let job A is older
-- A runs t=0-10. At t=10 it takes R and runs t=10-20. 
-- B runs t=0-15. At t=15 it takes S and runs t=15-25.
-- At t=20 A needs S (held by B) hence kills B and runs t=20-30. No wait.
-- Let job B is older
-- A runs t=0-10. At t=10 it takes R and runs t=10-20. 
-- B runs t=0-15. At t=15 it takes S and runs t=15-25.
-- At t=20 A needs S hence waits.
-- At t=25 B needs R it kill A and takes R and runs 25-33. No wait.
-- 
-- Job C: run(10) need(R)  run(10)  need(S) run(10)
-- Job D: run(15) need(S)  run(10)
-- Wait-die with C older. Here D is over at t=25. It frees S. C waits 20-25. Runs 25-35. Over at 35.
-- Wait-die with D older. Here at t=20 C needs S which is with older job hence suicides.
-- Wound-wait with C older. A kills B at t=20 and runs t=20-30.
-- Wound-wait with D older. Here D is over at t=25. It frees S. C waits 20-25. Runs 25-35. Over at 35.
-- Here Wait-die with C older and Wound wait with D older are successful. Others fail.
-- 
-- Job E: run(10) need(R)  run(10)  need(S) run(10)
-- Job F: run(15) need(R)  run(10)  need(S) run(8) 
-- Wait-die with E older. E occupies R at t=10. F Suicides at t=15.
-- Wait-die with F older. E is over at t=30. It releases R and S. F waits t=15-30 for R. It takes S at t=40. It is over at t=48.
-- Wound wait with E older. E is over at t=30. It releases R and S. F waits t=15-30 for R. It takes S at t=40. It is over at t=48.
-- Wound wait with F older. F kills E at t=15. Takes S at 25 and over at 33.



create table p (a int);
insert into p values (98),(37),(96),(21),(92);
select  a, case when a>30 then 59 when a<42 then 11 else Null end from p;

-- Output:
-- a	case when a>30 then 59 when a<42 then 11 else Null end
-- 98	59
-- 37	59
-- 96	59
-- 21	11
-- 92	59


create table p (a int,b int);
insert into p values (5,8),(6,3),(7,9);
with u (y,z) as (select a+b,a*b from p) select * from p,u;

-- Output:
-- a	b	y	z
-- 5	8	13	40
-- 5	8	9	18
-- 5	8	16	63
-- 6	3	13	40
-- 6	3	9	18
-- 6	3	16	63
-- 7	9	13	40
-- 7	9	9	18
-- 7	9	16	63


-- Multi value dependency in part of table
-- Every student is given marks by every teacher. Put following information in tables. More than one table permitted.
-- 
-- Student	Teacher	Marks
-- Anil	    Pankaj	  45
-- Hari	    Yogesh	  23
-- Anil	    Ravi	  76
-- Anil	    Yogesh	  82
-- Hari	    Pankaj	  58
-- Hari	    Ravi	  67

-- Write Sql query to output data inconsistency.

-- When Last row is deleted then output is following
-- 
-- Student	  teacher
-- Hari	      Ravi

-- It means student Hari is not evaluated by Ravi.

-- When (Anil Yogesh 82) is also deleted then output is 
-- 
-- Student	  teacher
-- Anil	      Yogesh
-- Hari	      Ravi

-- A: Write sql query so that output is as above
-- B: Write sql query so that output is "No error" in original table and "Error" when deletion is done.

create table p(Student,Teacher,Marks);
insert into p values ('Anil','Pankaj',45),('Hari','Yogesh',23),('Anil','Ravi',76),('Anil','Yogesh',82),('Hari','Pankaj',58);
select * from (select Student from p),(select teacher from p) except select Student,Teacher from p;
select distinct Student,(select Teacher from p y where (p.Student,y.Teacher) not in (select Student,Teacher from p)) k from p where k is not NULL;
--For which table both of these will produce different output

select case when (select student from (with u(student) as (select Student from p) select * from u, (select teacher from p) except select Student,Teacher from p)) is NULL then "no error" else "error" end;

-- Output:
-- Student	teacher
-- Hari	    Ravi
-- 
-- Student	k
-- Hari	    Ravi
-- 
-- case when (select student from (with u(student) as (select Student from p) select * from u, (select teacher from p) except select Student,Teacher from p)) is NULL then "no error" else "error" end
-- error


-- When the outputs are different
drop table if exists p;

create table p(Student,Teacher,Marks);
insert into p values ('Anil','Pankaj',45),('Anil','Ravi',76),('Anil','Yogesh',82),('Hari','Pankaj',58);
select * from (select Student from p),(select teacher from p) except select Student,Teacher from p;
select distinct Student,(select Teacher from p y where (p.Student,y.Teacher) not in (select Student,Teacher from p)) k from p where k is not NULL;
--For which table both of these will produce different output

select case when (select student from (with u(student) as (select Student from p) select * from u, (select teacher from p) except select Student,Teacher from p)) is NULL then "no error" else "error" end;

-- Output:
-- Student	teacher
-- Hari	    Ravi
-- Hari	    Yogesh
--
-- Student	k
-- Hari	    Ravi
--
-- case when (select student from (with u(student) as (select Student from p) select * from u, (select teacher from p) except select Student,Teacher from p)) is NULL then "no error" else "error" end
-- error




-- Assignment Part 2

-- An employee works in exactly one section. Every section has a set of managers. Every manager gives salary to its employee according to following table. Here Section->>Manager is present in (Employee, Section, Manager)
-- All managers of every section are same from view point of every Employee who works in that section.
-- Put following information in tables. More than one table is permitted.
-- 
-- Employee	Section	Manager	Salary	
-- Hari	       A	Suresh	300	
-- Hari	       A	Mohan	250	
-- Gyan	       B	Suresh	450	
-- Gyan	       B	Gopal	450	
-- Gyan	       B	Yogesh	370	
-- Anil	       A	Suresh	310	
-- Anil	       A	Mohan	300	
--
-- Write sql query for following
-- 1) Find employees in section A.
-- 2) How many managers section B has.
-- 3) How many managers section A has. 

create table p(employee,section,manager,salary);
insert into p values ('hari','a','suresh',300),('hari','a','mohan',250),('gyan','b','suresh',450),('gyan','b','gopal',450),('gyan','b','yogesh',370),('anil','a','suresh',310),('anil','a','mohan',300);
select distinct employee from p where section is 'a';
select count(*) from p where section='b';
select count(*) from (select distinct manager from p where section='a');

-- When following is also put then data inconsistency.
-- Anil	   A	Sani	350
-- From the view point of Hari section A has two managers: Suresh and Mohan.
-- From the view point of Anil it has 3 manages: Suresh Mohan Sani

-- Write sql query to output following
-- It means Anil finds in section A Sani as manager but Hari does not find.
-- employee 	section	   manager	 but_not
-- anil	        a	       sani	     hari

