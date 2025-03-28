-- Q1: Write missing in following
create table p (a int,b int,c int);
insert into p values missing
select distinct a,b from p; --output (2,3)(9,5)(9,8)
select distinct a,c from p; --output (2,6)(2,4)(9,1)

-- Solution: (2,3,6),(2,3,4),(9,5,1),(9,8,1)