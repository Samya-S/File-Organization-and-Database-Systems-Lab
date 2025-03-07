-- Timetable

-- Part A: Put information according to following table. A student can take multiple courses. However he can not take two courses in same slot.
-- 
--     Table P                Table Q
-- Student Course           Course Slot
-- Anil      OS               OS     A
-- Dipu      MA               CH     B
-- Gyan      CH               MA     H
-- Hari      PH               PH     B
-- Anil      PH               EN     L
-- Dipu      CH
-- 
-- After each of following see complete table of student,course,slot
-- 1. Put extra information. Gyan is in OS.
-- 2. Put Anil in CH. It should show error.
-- 3. Change course of Anil from PH to MA.
-- 4. Change course of Anil from OS to CH. Error.
-- 5. Change slot of PH to J.
-- 6. Change slot of PH to A. Error.


-- Part B: Make a separate table according to following information.
-- 
-- Table R
-- A  1M2T5
-- B  Tu1Tu2
-- C  M3W1W2
-- H  M6T8T9
-- L  Tu6Tu7Tu8
-- 
-- Write queries to answer following
-- 1.      Which slots are on Tuesday? Output A,B,H,L
-- 2.      How many hours are in slot C. Output 3
-- 3.      In which slots 8AM classes are. Output A,B,C
-- 4.      Which slot have common time with L Slot. Output:H
 

-- Part C: Put Dipu in EN.  Though slots are different but times are clashing.



-- My Solution
drop table if exists p;
drop table if exists q;
drop table if exists temp;
drop table if exists temp2;
drop table if exists r;


-- Part A

create table p (student char[10], course char[2]);
insert into p values ('Anil', 'OS'), ('Dipu', 'MA'), ('Gyan', 'CH'), ('Hari', 'PH'), ('Anil', 'PH'), ('Dipu', 'CH');

create table q (course char[2], slot char[1]);
insert into q values ('OS', 'A'), ('CH', 'B'), ('MA', 'H'), ('PH', 'B'), ('EN', 'L');

create table temp (
student char[10],
  course char[2],
  slot char[1],
    primary key (student, slot)
);
insert into temp (student, course, slot)
select p.student, p.course, q.slot from p join q on p.course = q.course;

-- 1. Put extra information. Gyan is in OS.
-- insert into temp values ('Gyan', 'OS', (select distinct slot from q where course='OS'));

-- 2. Put Anil in CH. It should show error.
-- insert into temp values ('Anil', 'CH', (select distinct slot from q where course='CH'));
-- Error: UNIQUE constraint failed: temp.student, temp.slot

-- 3. Change course of Anil from PH to MA.
-- update temp set course='MA', slot=(select slot from q where course='MA') where student='Anil' and course='PH';

-- 4. Change course of Anil from OS to CH. Error.
-- update temp set course='CH', slot=(select slot from q where course='CH') where student='Anil' and course='OS';
-- Error: UNIQUE constraint failed: temp.student, temp.slot

-- 5. Change slot of PH to J.
-- update temp set slot='J' where course='PH';

-- 6. Change slot of PH to A. Error.
-- update temp set slot='A' where course='PH';
-- Error: UNIQUE constraint failed: temp.student, temp.slot





-- Part B

create table r (slot char[2], day char[2], time int);
insert into r values ('A', 'M', 1), ('A', 'M', 2),('A', 'T', 5), ('B', 'T', 1), ('B', 'T', 2), ('C', 'M', 3), ('C', 'W', 1), ('C', 'W', 2), ('H', 'M', 6), ('H', 'T', 8), ('H', 'T', 9), ('L', 'T', 6), ('L', 'T', 7), ('L', 'T', 8);

-- 1. Which slots are on Tuesday? Output A,B,H,L
-- select distinct slot from r where day='T';

-- 2. How many hours are in slot C. Output 3
-- select count(time) from r where slot='C';

-- 3. In which slots 8AM classes are. Output A,B,C
-- select distinct slot from r where time=1;

-- 4. Which slot have common time with L Slot. Output:H
-- select distinct slot from r where (day, time) in (select day, time from r where slot='L') and slot!='L';





-- Part C

create table temp2 (
student char[10],
  course char[2],
  slot char[1],
  day char[2],
time int,
    primary key (student, day, time)
);
insert into temp2 (student, course, slot, day, time)
select student, course, temp.slot, day, time from temp join r on temp.slot = r.slot;

-- Put Dipu in EN.  Though slots are different but times are clashing.
insert into temp2 values ('Dipu', 'EN', (select slot from q where course='EN'), (select day from q where course='EN'), select time from q where course='EN')) -- wrong






-- Assignment Part 2
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'U'),("Hari","FODS",'J');
select p.student,p.course,a.course,p.slot from p as a,p where p.student=a.student and p.course!=a.course and p.slot=a.slot; -- To avoide duplicate use > in place of !=
select p.student,p.course,(Select u.course from p as u where u.slot=p.slot and p.student=u.student and p.course>u.course),p.slot from p where exists (select a.slot from p as a where p.student=a.student and p.course>a.course and p.slot=a.slot);
-----------Slot clash in Single table and double table
create table y(student char(7), course char(4));
insert into y values ("Anil","OS"),("Anil","CN"),("Anil","LA"),("Dipu","LA"),("Hari","ED"),("Hari","FODS");
create table z(course char(4),slot char(1));
insert into z values ("OS",'D'),("CN",'E'),("LA",'D'),("ED","U"),("FODS","J");
select y.student,y.course,a.course,z.slot from y as a,y,z as b,z where y.student=a.student and y.course>a.course and z.slot=b.slot and y.course=z.course and a.course=b.course;
select y.student,y.course,a.course,(select slot from z where z.course=y.course) as m from y as a,y where y.student=a.student and y.course>a.course and exists (select * from z as b,z where b.course=a.course and y.course=z.course and z.slot=b.slot);
--------------------Time clash------------------------------------------------
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'U'),("Hari","FODS",'J');
create table q(slot char(1),time char(4));
insert into q values ('D','M5'),('D','Tu3'),('D','Tu4'),('E','W5'),('E','Th4'),('E','F2'),('E','F3'),('U','M7'),('U','M8'),('U','Tu6'),('U','Tu7'),('J','M6'),('J','M7'),('J','M8');
select p.student,p.course,a.course,p.slot,a.slot from p as a,p where p.student=a.student and p.course>a.course and exists (select * from q as b,q where b.slot=a.slot and p.slot=q.slot and q.time=b.time);