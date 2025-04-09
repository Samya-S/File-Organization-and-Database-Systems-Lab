-- Q2: Write smallest missing in following
create table m (h int);
insert into m values (45),(57),(58),(86),(92);
with     
-- smallest missing     
select * from g as z,g where z.d=g.y;

-- output is following
-- 45	86	86	45
-- 57	86	86	45
-- 58	45	45	86
-- 86	45	45	86
-- 92	45	45	86

-- Solution:
g(y,d) as (select h,case when h<58 then 86 else 45 end from m) 