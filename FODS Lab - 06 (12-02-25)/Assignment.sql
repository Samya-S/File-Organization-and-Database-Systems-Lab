create table p(a int,b int);
create table q(c int);
insert into p values (1,5),(1,6),(2,7),(2,3);
insert into q values (3),(4);
--select * from p left join q where a=1; --(1,5,3)(1,5,4)(1,6,3)(1,6,4)
--select * from p left join q on a=1;--(1,5,3)(1,5,4)(1,6,3)(1,6,4)(2,7,)(2,3,)  Null values are used for those values of table p which are not covered.
--select * from p left join q on a=1 where b>5;--(1,6,3)(1,6,4)(2,7,)
--select * from p left join q where b>5;--(1,6,3)(1,6,4)(2,7,3)(2,7,4)
--select * from p left join q on b>5;--(1,5,)(1,6,3)(1,6,4)(2,7,3)(2,7,4)(2,3,) Order is important
--select * from p left join q on b>5 where a=1;--(1,5,)(1,6,3)(1,6,4)
select * from p left join q where a=1 and b>5; --(1,6,3)(1,6,4)
select * from p left join q on a=1 and b>5; --(1,5,)(1,6,3)(1,6,4)(2,7,)(2,3,)


-- A job is given time stamp (TS) when it starts. 
-- a=b+7 involves reading of b and writing a. Read time of b TR(b) and write time of a TW(a) are updated by the time stamp (TS) of the job.
-- Let initial values of P, Q and M are 74, 63 and 42 respectively
-- Time	    Job U TS=5	   Job V TS=7	 Job W TS=9	   P=74,TW(P)=0,TR(P)=0    Q=63,TW(Q)=0,TR(Q)=0    M=42,TW(M)=0,TR(M)=0
-- 10	    P=29	                                   P=29,TW(P)=5,TR(P)=0	
-- 12	                   Q=P+3	                   P=29,TW(P)=5,TR(P)=7	   Q=32,TW(Q)=7,TR(Q)=0	
-- 13	                                 P=Q*2	       P=64,TW(P)=9,TR(P)=7	   Q=32,TW(Q)=7,TR(Q)=9	


-- A job is given time stamp (TS) when it starts. 
-- a=b+7 involves reading of b and writing a. Read time of b TR(b) and write time of a TW(a) are updated by the time stamp (TS) of the job.
-- Following are exceptions : TR and TW of a variable can not decrease.
-- D1: TS of job which is trying to read b < TR(b) then RT(b) is not updated
-- D2: TS of job which is trying to write a < TW(a) then value of a and TW(a) are not updated. 
-- Following are error
-- E1: TS of job which is trying to write a < RT(a) then redo operation may be needed for the operation which was reading a.
-- E2: TS of job which is trying to read b < TW(b) then old value of b is read. 

-- Let initial values of P, Q and M are 74, 63 and 42 respectively
-- Time	     Job U TS=5	    Job V TS=7	   Job W TS=9	 P=74,TW(P)=0,TR(P)=0     Q=63,TW(Q)=0,TR(Q)=0    M=42,TW(M)=0,TR(M)=0
-- 10	     P=29	                                     P=29,TW(P)=5,TR(P)=0	
-- 12	                    Q=P+3	                     P=29,TW(P)=5,TR(P)=7	  Q=32,TW(Q)=7,TR(Q)=0
-- 13	                                   P=Q*2	     P=64,TW(P)=9,TR(P)=7	  Q=32,TW(Q)=7,TR(Q)=9	
-- 17	                    P=11	                     No change apply D2	
-- 20        M=Q+5                                                                No change  apply D1     M=68,TW(M)=5,TR(M)=0
--                                                                                                        Q is 63 (not 32) from E2

-- Above means at t=5 P=29 and M=Q+5 are done hence P=29 and M=63+5=68
-- At t=7 Q=P+3 and P=11 are done hence P=11 and Q=32
-- At t=9 P=Q*2 is done hence P=64
-- Finally P=64 Q=32 M=68 are achieved above. It became possible because of D2.and E2