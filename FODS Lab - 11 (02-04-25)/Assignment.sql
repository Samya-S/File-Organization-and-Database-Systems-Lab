-- Example 1: Let initial values of R and S be 56 and 79 respectively. Let a job does R=25 and S=89.
-- R is updated as 25. Now power fails.
-- When power arrives whole job is done again.
-- R is updated from 25 to 25. S is updated from 56 to 89. Though another update of R is useless but it does not create any harm.
-- Example 2: Let initial values of P and Q are 23 and 57 respectively. Let a job does P=P+5 and Q=Q-5.
-- P is updated as 28 now power fails.
-- When power arrives 
-- If job is done again P becomes 33 and Q 52.
-- If not done then Q is old value. 
-- Solution is Log.
-- Initial P:23 Q:57
-- P=P+5 write P:28 on log.
-- Q=Q-5 writes Q:52 in log.
-- When Job is complete "Over" is written on Log.
-- Values of P and Q are 23 and 57 till now.
-- Now log is done. P is updated as 28 and Q as 52.
-- Let power fails before "Over" written. Now Job is done again.
-- When power fails after "Over" written. Now Log is done again.
-- 
-- Every statement is put on log with read, write time stamp. K(a,b) means variable K is read by TS a and is updated by TS b.
-- 
--                 10	              12	            45	                54	             65	                69
-- Job A TS 1	                                                            K=U	
-- Job B TS 3	                   Write(U) U=14	
-- Job C TS 4	                                                                             Y=U	
-- Job D TS 6	   Write(U) U=23	
-- Job E TS 7	                                                                                               U=32
-- Job F TS 9	                                     Read(U)Write(M)M=U	
-- InitialU:19Log U(0,6)=23xxxxxx	U(0,3)=14xxxxxx	 M(0,9)=23U(9,6)	 K(0,1)=19U(1,0)	Y(0,4)=14U(4,3)	 U(9,7)=32=M(0,9)redo
-- 
-- At t=10 Value of U is updated as 23 by TS6 hence U(0,6). U(0,3) is similar. These statements are put on log. But value of U is not changed.
-- At t=45 the value of U is read by a time stamp job 9. Biggest time stamp lesser than or equal to 9 is 6. Hence U(,6) is taken.
-- This value is read by TS 9 hence U(9,6) is also written.
-- At t=54 the value of U is read by a time stamp job 1. Biggest time stamp lesser than or equal to 1 is 0. Hence old value is taken.
-- This value is read by TS 1 hence U(1,0) is also written.
-- At t=65 the value of U is read by a time stamp job 4. Biggest time stamp lesser than or equal to 4 is 3. Hence U(,3) is taken.
-- At t=69 U is updated by TS 7 job. Read time of U is 9. 9>7. It was done at t=45. Hence statement at t=45 is redone. 
-- When a variable has (Read u) and is updated by TS v (v<u) then redone may be needed.
-- 
-- When work is over then updates are made. Highest write time stamp of U is 7 hence it is updated as U(,7)=32
-- Highest time stamp of M is 9 but it is last updated at t=69 hence M=32 is final M.
-- 
-- TS 2	    J=43	                        J=72	
-- TS 1	                                                      J=29
-- TS 3	                  M=J	
-- Log	    J(0,2)=43	  M(0,3)=43J(3,2)	J(3,2)=72M(0,3)	  J(0,1)=29
-- 
-- Finally J is updated by highest TS job 2. It is last updated by TS2 job as 72.
-- M is updated by highest TS Job 3. It is last updated at t=20 hence it is put as 72.
-- At t=25 though Read(J)=3>1 still no redo.
-- 
-- TS 1	                                                                                       J=29
-- TS 2	    J=43	
-- TS 3	                                                        J=72	
-- TS 6	                  M=J	
-- TS 8	                                     Y=M	
-- Log	    J(0,2)=43	  M(0,6)=43J(6,2)	 Y(0,8)=43M(8,6)	J(6,3)=72M(8,6)andY(0,8)=72	   J(0,1)=29 no redo

create table p (a int,b int);
insert into p values (2,7),(5,9),(17,3),(2,11);
create trigger m after insert on P
  begin
    update p set a=a+1,b=new.a+b+17 where a<10;
  end;
insert into p values (2,4);
select * from p;
--replace after by before
