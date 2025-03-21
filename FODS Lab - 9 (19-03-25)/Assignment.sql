-- View Serializability  W(a,b) means Some variable is written at t=a by a job with time stamp b
-- W(a,b)-W(c,d) a<c and b>d is relaxed when W(p,q) exists p>c q>b
-- R(a,b)-W(c,d) a<c and b>d is relaxed when W(p,q) exists p<a and b>q>d
-- W(a,b)-R(c,d) a<c and b>d is relaxed when W(p,q) exists c>p>a and q<d
-- 
--                      10	                12	             45
-- Job A TS 1	                      Write(U) U=11	
-- Job B TS 2	    Write(U) U=23	
-- Job C TS 3	                                         Write(U) U=87
-- 
-- At t=1 U=11 at t=2 U=23 at t=3 U=87 are supposed to be done. Hence final U should be 87.
-- Let at t=10 U=23 at t=12 U=11 and at t=45 U=87 are actually done then also final U=87.
-- W(10,2)-W(12,1) is relaxed because of W(45,3)
-- 
--                     9	            11	            14	            17
-- Job A TS 1	                                  Write(V) V=91	
-- Job B TS 2	  Write(V) V=19	
-- Job C TS 3	                    Read(V) M=V	
-- Job D TS 4	                                                   Write(V) V=32
-- 
-- At t=1 V=91 at t=2 V=19 at t=3 M=V at t=4 V=32 are supposed to be done. Hence M should be 19.
-- Let at t=9 V=19 at t=11 M=V at t=14 V=91 at t=17 V=32 are actually done then also M=19.
-- R(11,3)-W(14,1) is relaxed because of W(9,2). W(9,2)-W(14,1) is relaxed because of W(17,4)
-- 
--                     14	            18	            23	            61
-- Job A TS 1	                  Write(J) J=82	
-- Job B TS 2	                                   Read(J) K=J	
-- Job C TS 3	   Write(J) J=78	
-- Job D TS 4	                                                   Write(J) J=99
-- 
-- at t=1 J=82 at t=2 K=J at t=3 J=78 at t=4 J=99 are supposed to be done. K is supposed to be 82.
-- Let at t=14 J=78 at t=18 J=82 at t=23 K=J at t=61 J=99 are actually done. K will be 82.
-- W(14,3)-R(23,2) is relaxed because of W(18,1). W(14,3)-W(18,1) is relaxed because of W(61,4)






-- Universal quantifier
create table p (a int,b int);
insert into p values (2,7),(5,9),(8,7),(2,9),(8,6),(5,7),(2,11),(5,11),(5,13),(6,11),(9,13);
create table q(b int); insert into q values (7),(9),(11); 
select distinct a from p where b in q; --select a from p where for some b in q (a,b) is in p; 2,5,8,6
-- Question: select a from p where for all b in q (a,b) is in p; 2,5   Write query It is also called p/q p division q in relational algebra


-- Solution
-- Universal quantifier
create table p (a int,b int);
insert into p values (2,7),(5,9),(8,7),(2,9),(8,6),(5,7),(2,11),(5,11),(5,13),(6,11),(9,13);
create table q(b int); insert into q values (7),(9),(11); 
select distinct a from p where b in q; --select a from p where for some b in q (a,b) is in p; 2,5,8,6
select distinct a as z from p 
where not exists (select a as m from p 
                  where z=m and exists (select b as y from q 
                                        where not exists (select a from p where m=a and y=b))); --p/q select a from p where for all b in q (a,b) is in p; 2,5 It is also called p/q p division q in relational algebra
-- It is also called p/q p division q in relational algebra

-- My Solution
-- Solution 1
select distinct a from p where not exists (select b as y from q where not exists (select a from p as u where u.a=p.a and y=b));
-- Solution 2
select distinct a from p where not exists (select b from q where (a,b) not in p);




-- Question
create table p (a int,b int);
insert into p values (2,7),(5,9),(7,3),(2,11),(3,6);
create table q (c int,d int);
insert into q values (2,5),(8,9),(7,12),(2,3);
select a,b,d from p left join q on a=c; ---How to get same output (order may be different without left join)

-- Solution
select a,b,d from p,q where a=c
union
select a,b,null from p,q where
a not in (select c from q where c=a);
