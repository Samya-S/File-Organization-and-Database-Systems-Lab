-- Q2: Write sql query to finds names of students of Gyan. Example: For Anil these are Hair, Kapil
create table P (name char(10), subject char(4));
create table Q (subject char(10), teacher char(9));
insert into P values ('Hari','LA'),('Hari','FODS'),('Kapil','CN'),('Kapil','LA'),('Ravi','OS');
insert into Q values ('LA','Anil'),('FODS','Dipu'),('CN','Gyan'),('OS','Lalit');

-- Solution:
select name from P where subject in (select subject from Q where teacher='Gyan');
