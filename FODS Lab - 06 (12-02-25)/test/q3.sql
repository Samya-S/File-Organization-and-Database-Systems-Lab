-- Question 3: Make only one table (smallest) and write smallest query to get output (241,42)(29,)(104,42)(21,)(89,42)

-- Solution:
create table p(a int);
insert into p values (241),(29),(42),(104),(21),(89);  --42 can be any where
select * from p as u left join p on u.a>50 and p.a=42 where u.a!=42;
