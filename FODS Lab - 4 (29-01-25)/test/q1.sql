-- Question 1: Following program outputs 15,93,27,37,81. Write smallest missing

create table p (a int);
insert into p values (15),(3),(93),(27),(25),(37),(69),(81);
select a from p where missing;

-- Solution:
select a from p where exists (select * from p as c where p.a=c.a+12);