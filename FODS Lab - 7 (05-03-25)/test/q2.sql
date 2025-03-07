-- Q2: Write smallest missing in following. Use smallest positive integers.
create table p(course char(3), start int, finish int);
insert into p values -- missing
select p.course,k.course,k.start,min(k.finish,p.finish) from p as k,p where p.course!=k.course and p.start<k.start and k.start<p.finish; 
-- Output is following:
-- course	course	start	min(k.finish,p.finish)
-- OS	    CN	      11	     17
-- OS	    ED	      22	     29
-- ED	    FODS	  35	     40
-- ED	    LA	      44	     47

-- Solution:
-- ("OS",1,29),("CN",11,17),("ED",22,47),("FODS",35,40),("LA",44,47);