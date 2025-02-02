-- Question 2: Following program outputs 4 courses.  
--             Write missing smallest. Heavy deduction when not smallest.

create table p (course char(10),name char(10));
insert into p values ('OS','Anil'), ('OS','Dipu'),('OS','Gyan'),('CN','Dipu'),('CN','Hari'),('FODS','Anil'), ('FODS','Hari'), ('COA','Gyan'), ('BE','Gyan'),('BE','Hari'),('BE','Lalit');
Insert into p values missing;
select a.course from p as a,p as b where a.course=b.course and a.name='Anil' and b.name='Gyan';

-- Solution: ('FODS','Gyan'),('COA','Anil'),('M','Anil'),('M','Gyan')