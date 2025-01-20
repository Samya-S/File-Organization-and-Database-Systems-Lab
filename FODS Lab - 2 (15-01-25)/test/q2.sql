-- Question 2: Make all possible tables for p in following
create table p (a int,b int,c int);
insert into p values missing;
select distinct a,b from p;--(2,5)(2,7)(1,5)
select distinct a,c from p;--(2,8)(2,3)(1,3)
select distinct b,c from p;--(7,3)(5,8)(5,3)

-- Solution:
-- (2,5,8),(2,7,3),(2,5,3),(1,5,3);  or (2,5,8),(2,7,3),(1,5,3);
