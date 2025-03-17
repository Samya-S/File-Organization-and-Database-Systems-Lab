-- Q3: Output all slot clash. Write smallest missing.
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'A'),("Hari","FODS",'A'),("Anil","UV",'D');
select student,course
-- missing --
k!=h and slot=u;
-- Output is following
-- Anil	  LA	  OS	  D
-- Hari	  FODS	  ED	  A
-- Anil	  UV	  OS	  D

-- Solution:
select student,course 
as h,(Select y.course from p as y where p.student=y.student and p.slot=y.slot) as k, slot as u from p where 
k!=h and slot=u;
