-- Conflict is caused when
-- 1) A job with lower time stamp tries to write a variable which was read/written by a higher time stamp job.
-- 1) A job with lower time stamp tries to read a variable which was written by a higher time stamp job.
-- 
--                 10	     12	      18	    20	     24	      27	    30	      35
-- Job U TS 3	          Write(K)  Write(H)                                        Read(M)
-- Job V TS 1	                              Read(M)  Read(K)  Write(D)	
-- Job W TS 2	  Read(D) 	                                              Write(H)
-- 
-- Following conflicts are present.
-- 1) At t=24 Job V is reading(K). It was updated at t=12 by U. TS(U)>TS(V)  W-R conflict  W(12,3)-R(24,1)  12<24 3>1
-- 2) At t=27 Job V is updating(D). It was read at t=10 by W. TS(W)>TS(V)    R-W conflict  R(10,2)-W(27,1)
-- 3) At t=30 Job W is updating(H). It was already updated at t=18 by U. TS(U)>T(W)  W(18,3)-W(30,2) 
-- When jobs U,V,W are given time stamps 1,3,2 respectively then there is no conflict.  
-- In that case at t=35 U reads M which was already read by V at 20 and TS(V)>T(U). But R-R conflict permitted. 
-- W(a,b)-W(c,d)    W(a,b)-R(c,d)  and   R(a,b)-W(c,d)    a<c and b>d are conflicts.
-- 
-- 
-- In following no time stamp is possible.
-- 
--             10	      12	    17	      19	     29	       46	      56	    62	
-- Job G	  read(U)	                                                    read(W)	
-- Job H	           write(V)	  write(U)	                     read(Y)	
-- Job I	                                                                          write(Y)	
-- Job J	                                write(W)   write(V)	
-- 
-- Reason: [U(10,17) TS(G)<TS(H)] [V(12,29) TS(H)<TS(J)] [W(19,56) TS(J)<TS(G)] GHJG is cycle.
-- Hence GHIJ schedule is non-serializable

-- Q1: Change course of Anil from OS to ED. 
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'A'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'E'),("Hari","FODS",'J');
Update p set course="ED",slot=(select slot from p where course="ED")  where student="Anil" and course="OS";
-- change not permitted when Anil has another course with same slot. Anil OS->ED not permitted  OS->FODS permitted 
Update p set course="ED",slot=(select slot from p where course="ED")  where student="Anil" and course="OS" and ((select slot from p where course="ED") not in (select slot from p where student="Anil")) ; 
-- A: Write mistake in above and correct it.

-- B: Use the method of insert delete. Do not permit change when slot clash
delete from p where student="Anil" and course="OS";
insert into p values ("Anil","ED",(Select slot from p where course="ED"));

-- C: Change of course not permitted if no student in a course. Anil CN->ED not permitted  Anil LA->ED permitted. Slot clash is no issue. Reason Anil is only student in CN. Write program



-- Q2: ("OS",44,52) means course OS is during t=44-52. 
-- The program finds common time between two courses. For which input program will fail.  How to correct it? What minimum modifications are needed. 
-- Caution: Duplicated output
create table p(course char(7),start int,finish int);
insert into p values ("LA",1,33),("ED",11,17),("CN",32,52),("FODS",35,40),("OS",44,52);
select p.course,k.course,k.start,min(k.finish,p.finish) from p as k,p where p.course!=k.course and p.start<k.start and k.start<p.finish; 
-- Output is following:
-- course	course	start	min(k.finish,p.finish)
--   LA	     ED	      11	        17
--   LA	     CN	      32	        33
--   CN	     FODS	  35	        40
--   CN	     OS	      44	        52


-- Q3: Time clash of slots is also outputted.
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'U'),("Hari","FODS",'J');
create table q(slot char(1),time char(4));
insert into q values ('D','M5'),('D','Tu3'),('D','Tu4'),('E','W5'),('E','Th4'),('E','F2'),('E','F3'),('U','M7'),('U','M8'),('U','Tu6'),('U','Tu7'),('J','M6'),('J','M7'),('J','M8');
select p.student,p.course,k.course,(select q.time from q as y,q where q.slot=p.slot and y.slot=k.slot and q.time=y.time) as time_clash from p as k,p where p.student=k.student and p.course>k.course and exists (select * from q as b,q where b.slot=k.slot and p.slot=q.slot and q.time=b.time);

select p.student,p.course,k.course,(select y.time from q as y where      
-- missing --
as time_clash from p as k,p where p.student=k.student and p.course>k.course and exists (select * from q as b,q where b.slot=k.slot and p.slot=q.slot and q.time=b.time);
-- Write different missing




-- additional assignment 

-- Q1: Change course of Anil from OS to ED. 
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'A'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'E'),("Hari","FODS",'J');
Update p set course="ED",slot=(select slot from p where course="ED")  where student="Anil" and course="OS";
-- change not permitted when Anil has another course with same slot. Anil OS->ED not permitted  OS->FODS permitted CN->ED should be permitted
Update p set course="ED",slot=(select slot from p where course="ED")  where student="Anil" and course="OS" and ((select slot from p where course="ED") not in (select slot from p where student="Anil")) ; 
-- Write mistake in above. CN->ED should be permitted

-- Use the method of insert delete. Do not permit change when slot clash
delete from p where student="Anil" and course="OS";
insert into p values ("Anil","ED",(Select slot from p where course="ED"));

-- Change of course not permitted if no student in a course. Anil CN->ED not permitted  Anil LA->ED permitted. Slot clash is no issue.
-- Reason Anil is only student in CN
Update p set course="ED",slot=(select slot from p where course="ED")  where student="Anil" and course="LA" and exists (select student from p where course="LA" and student!="Anil");


-- Q2: ("OS",44,52) means course OS is during t=44-52. 
-- The program finds common time between two courses. For which input program will fail.  How to correct it? What minimum modifications are needed. 

create table p(course char(7),start int,finish int);
insert into p values ("LA",11,33),("ED",11,17),("CN",32,52),("FODS",35,40),("OS",44,52);
select p.course,k.course,k.start,min(k.finish,p.finish) from p as k,p where p.course!=k.course and p.start<k.start and k.start<p.finish; Output is following:
-- course	course	start	min(k.finish,p.finish)
--   LA	     ED	     11	             17
--   LA	     CN	     32	             33
--   CN	     FODS	 35	             40
--   CN	     OS	     44	             52
-- Ans ("LA",11,33) Caution: Duplicated output  Try to correct it. Duplicate solution

-- Q3: Time clash of slots is also outputted.
create table p(student char(7), course char(4), slot char(1));
insert into p values ("Anil","OS",'D'),("Anil","CN",'E'),("Anil","LA",'D'),("Dipu","LA",'D'),("Hari","ED",'U'),("Hari","FODS",'J');
create table q(slot char(1),time char(4));
insert into q values ('D','M5'),('D','Tu3'),('D','Tu4'),('E','W5'),('E','Th4'),('E','F2'),('E','F3'),('U','M7'),('U','M8'),('U','Tu6'),('U','Tu7'),('J','M6'),('J','M7'),('J','M8');
select p.student,p.course,k.course,(select q.time from q as y,q where q.slot=p.slot and y.slot=k.slot and q.time=y.time) as time_clash from p as k,p where p.student=k.student and p.course>k.course and exists (select * from q as b,q where b.slot=k.slot and p.slot=q.slot and q.time=b.time);
select p.student,p.course,k.course,(select y.time from q as y where y.slot=p.slot and y.time in (select time from q where slot=k.slot) limit 1 ) as time_clash from p as k,p where p.student=k.student and p.course>k.course and exists (select * from q as b,q where b.slot=k.slot and p.slot=q.slot and q.time=b.time);
select p.student,p.course,k.course,(select y.time from q as y where y.slot=p.slot and exists(select * from q as b where b.slot=k.slot and y.time=b.time) ) as time_clash from p as k,p where p.student=k.student and p.course>k.course and exists (select * from q as b,q where b.slot=k.slot and p.slot=q.slot and q.time=b.time);
