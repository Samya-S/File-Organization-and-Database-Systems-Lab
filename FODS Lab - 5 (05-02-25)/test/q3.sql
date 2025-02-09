-- Q3: Following outputs 18,34,17,73,61. Write missing smallest.  Heavy deduction on non smallest.

create table p (a int,b int,primary key(a,b));
insert into p values (34,1),(61,3),(34,2),(34,3),(17,1), -- missing smallest ;
select a from p group by a order by count(b),a desc;

-- Solution:
-- (18,1),(17,2),(17,3),(73,1),(73,2),(73,3),(73,4),(61,1),(61,2),(61,4)