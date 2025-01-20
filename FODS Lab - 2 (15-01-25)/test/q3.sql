-- Question 3: Write query to find all diseases looked by ramesh in following. Expected output malaria,flu
create table q(patient char (10),disease char (10));
create table r(patient char (10),doctor char(5));
insert into q values ('anil','plague'),('dipu','malaria'),('gyan','plague'),('hari','jaundice'),('lalit','flu');
insert into r values ('anil','yogesh'),('dipu','ramesh'),('gyan','yogesh'),('hari','virendra'),('lalit','ramesh');

-- Solution:
select disease from q where patient in (select patient from r where doctor='ramesh');
