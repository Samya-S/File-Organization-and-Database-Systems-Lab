-- Q2: Write smallest query to find maximum element.

create table g (h int);
insert into g values (10),(3),(93),(17),(30),(37),(79),(86);
-- missing query so that output is 93. In general maximum.

-- Solution:
select * from g except select g.h from g,g as r where g.h<r.h;
select r.h from g as r where not exists (select * from g where r.h<g.h);
