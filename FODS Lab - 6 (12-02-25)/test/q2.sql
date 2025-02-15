-- Question 2: What are missing-1 and missing-2 smallest.
create table p(a int);create table q(b int);
insert into p values (1),(2),(3),(4),(5),(6),(7),(8),(9);
insert into q values (9);
select * from p left join q on missing-1  where missing-2 ;  --output (1,)(3,)(4,9)(6,)
select * from p left join q on missing-2  where missing-1 ;  --output (4,9)(5,)(7,)


-- Solution:
select * from p left join q on a in (4,5,7) where a in (1,3,4,6);--output (1,)(3,)(4,9)(6,)
select * from p left join q on a in (1,3,4,6) where a in (4,5,7);--output (4,9)(5,)(7,)
