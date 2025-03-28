-- Q3: Write smallest missing is following. Time clash of slots is also outputted.
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'U'),("Hari","FODS",'J');
create table q(slot char(1),time char(4));
insert into q values ('D','M5'),('D','Tu3'),('D','Tu4'),('E','W5'),('E','Th4'),('E','F2'),('E','F3'),('U','M7'),('U','M8'),('U','Tu6'),('U','Tu7'),('J','M6'),('J','M7'),('J','M8');
select p.student,p.course,z.course,(select q.time from q as w     --missing--    
    where p.student=z.student and p.course>z.course and exists (select * from q as b,q where b.slot=z.slot and p.slot=q.slot and q.time=b.time);
-- Output is following. 
-- In place of M5 Tu3 or Tu4 may come. In place of M7 M8 can come.
-- student	course	course	clash_in_time
-- Anil	    OS	      LA	      M5
-- Hari	    FODS	  ED	      M7

-- Solution:
select p.student,p.course,z.course,(select q.time from q as w
    ,q where q.slot=p.slot and w.slot=z.slot and q.time=w.time) as clash_in_time from p as z,p -- missing part
    where p.student=z.student and p.course>z.course and exists (select * from q as b,q where b.slot=z.slot and p.slot=q.slot and q.time=b.time);