-- Q3: Write smallest missing in following. Order is important.
create table p(Student,Teacher);
insert into p values -- smallest missing
select distinct Student,(select Teacher from p y where (p.Student,y.Teacher) not in (select Student,Teacher from p)) k from p where k is not NULL;
-- Output is following
-- Sani	  Gopal
-- Hari	  Dipu
-- Ravi	  Pankaj

-- Solution:
insert into p values ('Sani','Dipu'),('Sani','Pankaj'),('Hari','Gopal'),('Ravi','Dipu');
