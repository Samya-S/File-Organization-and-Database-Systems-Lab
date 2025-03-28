-- Extended hashing: Bucket size 3.
-- An element is put into the corresponding bucket. 
-- When the corresponding bucket is full then the new element goes to free bucket. The corresponding bucket is split.
-- Few elements of the old bucket are transferred to new if needed.
-- 
-- Put 17	all:17	
-- Put 18	all:17,18	
-- Put 23	all:17,18,23	
-- Put 25	all:17,18,23	25	                                         25 goes to new bucket. 
--          even:18	        odd:25,17,23	                             1K+0 is split into even:2K+0 and odd:2K+1     Odd elements transferred
-- Put 14	even:18,14	    odd:25,17,23	
-- Put 88	even:18,14,88	odd:25,17,23	
-- Put 56	18,14,88	                    56	                         2K+0(even) is split into 4K+0 and 4K+2   new element 56 is 4K hence 4K elements are transferred.
--          4K+2:18,14	                    4K:56,88	
-- Put 22	4K+2:18,14,22	                4K:56,88	
-- Put 82	8K+6:14,22	                    4K:56,88        8K+2:82,18   4K+2 is split into 8K+2 and 8K+6
-- Put 80	                                4k:56,88,80     8K+2:82,18	
-- Put 84	                                8K:56,88,80                  8K+4:84  Split of 4K. But no element transfer.
-- 
-- Above was single split at one time. 
-- When corresponding bucket is full then the new element goes to free bucket. The corresponding bucket is split.
-- When after split the type of new element and type of all elements are same then. Another split may be needed.
-- 
-- Put 17	all:17	
-- Put 18	all:17,18	
-- Put 21	all:17,18,21	
-- Put 25	all:17,18,21	25	                             Bucket size 3. It is full hence 25 goes to new bucket. all is decomposed into two parts: even odd
--                          odd:25	                         25 is odd hence new bucket is odd.
--          even:18	        odd:25,17,21	                 1K+0 is split into even:2K+0 and odd:2K+1     Odd elements transferred to new bucket
-- Put 29	even:18	        odd:25,17,21	   29	         29 goes to new bucket. odd(2K+1) is split into 4K+1 and 4K+3. All 25,17,21,29 are 4K+1
--                          4K+3,8K+1:	       8K+5:29	     Now 4K+1 is split into 8K+1 and 8K+5. 29 is 8K+5. Hence new bucket is 8K+5.
-- xxxxxx	                4K+3,8K+1:25,17	   8K+5:29,21	 8K+5 elements of 25,17,21 are transferred to new bucket.
-- 
-- Above was multiple split. Here two categories may reside in same bucket. 
-- 
-- Put 17	all:17	
-- Put 19	all:17,19	
-- Put 23	all:17,19,23	
-- Put 25	all:17,19,23	    25	                        Bucket is full. 25 goes to new bucket. even odd two categories. All elements odd. 
--         even,4K+3:19,23	    4K+1:25,17	                odd has 4K+1, 4K+3. 25 is 4K+1. Hence new bucket is 4K+1. Hence 17 is transferred.
-- Put 14	even:4K+3:19,23,14	
-- Put 88			                          88	        88 goes to new bucket. Old bucket (even,4K+3) is decomposed into (even)(4K+3).
-- xxxxxx	4K+3:19,23,	                      even:88,14	88 is even hence even moves to new bucket. 14 is also transferred.
-- 
-- Above was separation of category. Following is split into sub-category.
-- 
-- Put 17	all:17	
-- Put 19	all:17,19	
-- Put 23	all:17,19,23	
-- Put 25	all:17,19,23	    25	                        Bucket is full. 25 goes to new bucket. even odd two categories. All elements odd. 
--         even,4K+3:19,23	    4K+1:25,17	                odd has 4K+1, 4K+3. 25 is 4K+1. Hence new bucket is 4K+1. Hence 17 is transferred.
-- Put 15	even:4K+3:19,23,15	
-- Put 87			                         87	            87 goes to new bucket. Old bucket (even,4K+3) has all elements 4K+3. 
-- xxxxxx	even:8K+3:19	                 8K+7:87,15,23	Hence 4K+3 is decomposed into 8K+3 and 8K+7. 87 is 8K+7. 15 and 23 transferred.
-- Put 12	even:8K+3:19,12	
-- Put 14	even:8K+3:19,12,14	
-- Put 43	even:12,14	                                    8K+3:43,19
-- 
-- Following is cascade of split
-- 
-- Put 17	all:17	
-- Put 21	all:17,21	
-- Put 25	all:17,21,25	                                xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- Put 29	                        29	                    all becomes even,odd. Odd becomes 4K+1, 4K+3. All elements 4K+1.
-- xxxxxx	even,4K+3,8K+1:17,25	8K+5:29,21	            4K+1 splits into 8K+1 and 8K+5. 29 is 8K+5 hence 8K+5 is new bucket with 21
-- Put 88	even,4K+3,8K+1:17,25,88	
-- Put 15	even,8K+1:17,25,88	                 4K+3:15	4K+3:15 is new bucket. No element is transferred.



-- Universal quantifier
create table p (a int,b int);
insert into p values (2,7),(5,9),(8,7),(2,9),(8,6),(5,7),(2,11),(5,11),(5,13),(6,11),(9,13);
create table q(b int); insert into q values (7),(9),(11); 
select distinct a from p where b in q;--select a from p where for some b in q (a,b) is in p; 2,5,8,6
select distinct a as z from p where not exists (select a as m from p where z=m and exists (select b as y from q where not exists (select a from p where m=a and y=b))); --p/q select a from p where for all b in q (a,b) is in p; 2,5 It is also called p/q p division q in relational algebra
-- It is also called p/q p division q in relational algebra
-- Method 2:
create table r as select * from (select a from p),q;
create table s as select * from r except select * from p;
select a from p except select a from s;


-- Left Join
create table p (a int,b int);insert into p values (2,7),(5,2);
create table q (b int,a int);insert into q values (2,6),(4,2);
select * from p union select * from q;
select * from q union select * from p; --What is difference between them
select * from (select * from p union select * from q) where a=2;
select * from (select * from q union select * from p) where a=2;

create table p (a int,b int,c int);insert into p values (2,7,11),(5,2,12),(8,3,13),(2,5,14),(3,2,15);
select a,(select c from p as u where p.a=u.b) from p;--NULL values

create table u (a int,b int);
insert into u values (2,7),(5,9),(8,7),(6,11),(9,13),(4,NULL);
select * from u where b is NULL;
select * from u where b is not NULL;

create table p (a int,b int);
insert into p values (2,7),(5,9),(7,3),(2,11),(3,6);
create table q (c int,d int);
insert into q values (2,5),(8,9),(7,12),(2,3);
select a,b,d from p left join q on a=c; ---How to get same output (order may be different without left join)

-- My Solution
select a,b,d from p,q where a=c
union
select a,b,null from p,q where
a not in (select c from q where c=a);
