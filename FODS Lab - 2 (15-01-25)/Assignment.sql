create table p (a int,b int,c int,primary key(b));
insert into p values (2,7,1),(5,9,4),(7,3,6),(2,8,9);
delete from p where b=9;
select * from p;
insert into p values (9,16,4);--replace 16 by 3 is error. key b two tuples with same b;
insert into p values ((select c from p where a=2),1,4);
select * from p;


create table p (a int,b int,c int);
insert into p values (2,7,1),(5,9,4),(7,3,1),(2,8,1);
create table q as select distinct a,c from p;
create table r as select distinct a,b from p;
select * from q;--(2,1)(5,4)(7,1) is ac
select * from r;--(2,7)(5,9)(7,3)(2,8) is ab
-- Question: Given table ac(2,1)(5,4)(7,1) and ab(2,7)(5,9)(7,3)(2,8). Make all possible tables abc. It gives unique answer.
-- Decomposition of abc (2,7,1),(5,9,4),(7,3,1),(2,8,1); into ab and ac is lossless. Because original table abc can be restored from ab and ac.

create table p (a int,b int,c int);
insert into p values (2,7,1),(5,9,4),(7,3,1),(2,8,1);
create table q as select distinct a,c from p;
create table r as select distinct b,c from p;
select * from q;--(2,1)(5,4)(7,1) is ac
select * from r;--(3,1)(7,1)(9,4)(8,1) is bc
-- If following is used still same ac and bc are obtained.
insert into p values (2,7,1),(5,9,4),(2,3,1),(7,8,1);
-- Given table ac(2,1)(5,4)(7,1) and bc(7,1)(9,4)(3,1)(8,1) following are possible abc
-- (2,7,1),(5,9,4),(7,3,1),(2,8,1); and (2,7,1),(5,9,4),(2,3,1),(7,8,1); and (7,7,1),(5,9,4),(2,3,1),(7,8,1); and (2,7,1),(5,9,4),(7,3,1),(2,8,1),(2,3,1); and few more;
-- Decomposition of abc (2,7,1),(5,9,4),(7,3,1),(2,8,1); into bc and ac is lossy. Because there are multiple possible table abc.

-- Every patient has one disease.
-- For every disease there is one doctor.
-- A doctor may look after more than one disease.
create table p(patient char (10),disease char (10),doctor char(5), primary key (patient));
insert into p values ('anil','plague','yogesh'),('dipu','malaria','mohan'),('gyan','plague','yogesh'),('hari','jaundice','virendra'),('lalit','flu','mohan');
select * from p;
-- 1: Put information kapil has malaria. Now find all patients of mohan.
-- 1A: Put information hari has malaria. Now find all patients of mohan.
-- 2: Hari has cured hence remove from table. Now find doctor of Jaundice.
-- 3: A doctor surendra for allergy has been appointed. Now find doctor of allergy.
-- 4: Put information: Jalaj has malaria and doctor sani is looking him.




-- Solutions:

drop table ac;
drop table ab;
drop table abc;

create table ac (a int, c int);
insert into ac values (2,1),(5,4),(7,1);

create table ab (a int, b int);
insert into ab values (2,7),(5,9),(7,3),(2,8);

create table abc as select * from ab join ac using (a);

------------------------------------------------------------


drop table ac;
drop table bc;
drop table abc;

create table ac (a int, c int);
insert into ac values (2,1),(5,4),(7,1);

create table bc (b int, c int);
insert into bc values (7,1),(9,4),(3,1),(8,1);

create table abc as select * from ac join bc using (c);

------------------------------------------------------------


drop table p;

create table p(patient char (10),disease char (10),doctor char(5), primary key (patient));
insert into p values ('anil','plague','yogesh'),('dipu','malaria','mohan'),('gyan','plague','yogesh'),('hari','jaundice','virendra'),('lalit','flu','mohan');

-- 1: Put information kapil has malaria. Now find all patients of mohan.
insert into p values ('kapil', 'malaria', (select doctor from p where disease='malaria')); -- more work in insertion. Doctor is to be found in nested query.
select patient from p where doctor='mohan';

-- 1A: Put information hari has malaria. Now find all patients of mohan.
-- insert into p values ('hari', 'malaria', (select doctor from p where disease='malaria'));
-- Error: UNIQUE constraint failed: p.patient
-- select patient from p where doctor='mohan';

-- 2: Hari has cured hence remove from table. Now find doctor of Jaundice.
delete from p where patient='hari';
select doctor from p where disease='jaundice'; -- information lost during deletion

-- 3: A doctor surendra for allergy has been appointed. Now find doctor of allergy.
-- insert into p values (, 'allergy', 'surendra'); -- error
select doctor from p where disease='allergy'; -- Inability to put certain information.

-- 4: Put information: Jalaj has malaria and doctor sani is looking him.
insert into p values ('jalaj', 'malaria', 'sani'); -- Data inconsistency not prevemted. For every disease there is one doctor.
select distinct doctor from p where disease='malaria'; -- 2 doctors for same disease not permitted

------------------------------


-- Solution (by sir):
insert into p values ('kapil','malaria',(select doctor from p where disease='malaria'));--more work in insertion. Doctor is to be found in nested query.
select patient from p where doctor='mohan';
delete from p where patient='hari';
select doctor from p where disease='jaundice'; --information lost during deletion
--insert into p values ( ,'allergy','surendra'); --error
select doctor from p where disease='allergy'; --Inability to put certain information.
insert into p values ('Jalaj','malaria','sani'); --Inconsistent information is not stopped. For every disease there is one doctor.
select distinct doctor from p where disease='malaria'; --2 doctors for same disease not permitted

------------------------------------------------------------
------------------------------------------------------------



-- Do above problems in following tables
create table q(patient char (10),disease char (10), primary key (patient));
create table r(disease char (10),doctor char(5), primary key (disease));
insert into q values ('anil','plague'),('dipu','malaria'),('gyan','plague'),('hari','jaundice'),('lalit','flu');
insert into r values ('plague','yogesh'),('malaria','mohan'),('jaundice','virendra'),('flu','mohan');


-- Solution:

drop table q;
drop table r;

create table q(patient char (10),disease char (10), primary key (patient));
create table r(disease char (10),doctor char(5), primary key (disease));
insert into q values ('anil','plague'),('dipu','malaria'),('gyan','plague'),('hari','jaundice'),('lalit','flu');
insert into r values ('plague','yogesh'),('malaria','mohan'),('jaundice','virendra'),('flu','mohan');

-- 1: Put information kapil has malaria. Now find all patients of mohan.
insert into q values ('kapil', 'malaria');
select patient from q where disease in (select disease from r where doctor='mohan'); -- more work in finding patient doctor relationship.

-- 1A: Put information hari has malaria. Now find all patients of mohan.
-- insert into q values ('hari', 'malaria'); -- Error: UNIQUE constraint failed: q.patient
select patient from q where disease in (select disease from r where doctor='mohan'); -- more work in finding patient doctor relationship.

-- 2: Hari has cured hence remove from table. Now find doctor of Jaundice.
delete from q where patient='hari';
select doctor from r where disease='jaundice';

-- 3: A doctor surendra for allergy has been appointed. Now find doctor of allergy.
insert into r values ('allergy', 'surendra');
select doctor from r where disease='allergy';

-- 4: Put information: Jalaj has malaria and doctor sani is looking him.
insert into q values ('jalaj', 'malaria');
-- insert into r values ('malaria', 'sani'); -- Error: UNIQUE constraint failed: r.disease
-- Data inconsistency prevemted. For every disease there is one doctor.

------------------------------


-- Solution (by sir):
insert into q values ('kapil','malaria');
select patient from q where disease in(select disease from r where doctor='mohan'); --more work in finding patient doctor relationship.
delete from q where patient='hari';
select doctor from r where disease='jaundice';
insert into r values ('allergy','surendra'); 
select doctor from r where disease='allergy';
insert into q values ('Jalaj','malaria');
--insert into r values ('malaria','sani'); its execution shows error