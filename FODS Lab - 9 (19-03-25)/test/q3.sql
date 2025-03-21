-- Q3: Write output of following. 
-- Notation: insert into p values (5..7,3),(6..8,8) means insert into p values (5,3),(6,3),(7,3),(6,8),(7,8),(8,8)
create table p (a int,b int);
insert into p values (17..32,7),(25..43,9),(23..27,4),(30..45,5);
create table q(b int); insert into q values (7),(9); 
select distinct a from p where a not in (select a from p where exists (select b from q where (a,b) not in p)) and exists (select b from p as y where p.a=y.a and b not in q);

-- Solution: 25,26,27,30,31,32