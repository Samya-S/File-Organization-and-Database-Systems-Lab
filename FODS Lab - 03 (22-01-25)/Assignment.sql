-- Let us consider following relation. Here an element of set A is related to exactly one element of set B. However an element of Set B is related to many (m) elements of set A. m=0,1,2.. Let maximum m is k. Let set A has n elements.

-- A    0    1    2    3    4    5    6    7    8    9   10   11
-- B  104  102  104  105  103  100  104  102  104  102  104  100

-- Let it is stored as it is. Following program is used to answer.

-- #include<stdio.h>
-- main(){  
--     int b[]={104,102,104,105,103,100,104,102,104,102,104,100}; 
--     int u,i;
--     scanf("%d",&u);
--     if(u<100) 
--         printf("%d",b[u]);
--     else
--         for(i=0;i<12;i++)  
--             if(b[i]==u) printf("%d,",i);
-- }

-- Given an element of set A the element of B can be found in O(1) time. It is minimum possible.
-- Given an element of set B the element of A can be found in O(n) time.



-- 0: What is minimum (in theory) possible complexity to find an element of A from B?
-- 1: Write program so that time to find element of A from B is minimum possible.  B from A may be O(n).
-- 2: A from B is minimum possible. Try to reduce B from A.



create table p (a int,b int,c int,d int,primary key(c,d));
insert into p values  (1,2,5,6),(1,3,5,7),(4,3,8,7),(1,9,8,6),(4,2,5,10);
-- error on primary key(a,c) primary key(a,d) primary key(b,c) primary key(b,d)
-- No error on primary key(a,b)
-- No error on primary key(a,b,c) Reason when ab is key then abc has to be key. It is called super key.
-- Here ab and cd are candidate keys. Super keys are ab, cd, abc, abd, acd, bcd, abcd.
-- Minimal super keys are called candidate keys.



-- (p,q,r):(1,2,7)(1,5,8)(1,2,9)(6,3,8)
-- When p is 1 q may be 2 or 5 
-- When p is 6 q is 3
-- When q is 2 p is 1 because in first and third tuple b is 2 in both of them a is 1 
-- When q is 5 p is 1
-- When q is 3 p is 6
-- Hence given q one can always find p. Hence functional dependency q->p is present. 
-- When q->p is present then in the table of pq key is q. (1,2)(1,5)(6,3) all tuples have different q.
-- When all q's are distinct then it is trivial function dependency. In this case q becomes key.
-- However given p one may not be able to find q. Reason in first and second tuple p is 1 but q are different 2 and 5.
-- Q->R absent q=2 in first and third tuple but r are 7 and 9 respectively.
-- P->R is absent p=1 in first 3 tuples but r are different.
-- R->P and R->Q are absent because in second and fourth tuple r is 8 but p and q are different.
-- In above given p and r both one may find q. Functional dependency pr->Q. However it is trivial because no two tuples have same p and r. Here key is pr.
-- In (1,2,7)(1,5,8)(1,2,9)(6,3,8)(6,4,8) when p=6 and r=8 then q may be 3 or 4 hence PR->Q absent.
-- When PR->Q is absent then P->Q and R->Q has to be absent.
-- (1,2,3)(1,5,3)(4,2,6)(4,7,8)(9,7,6) PQ->R and QR->P holds. No other functional dependency (FD) holds. Hence PQ and QR are keys.
-- Make instance P->R and Q->R present. No other FD present.
-- Make instance Q->P, P->Q, R->P and R->Q absent. PR->Q and QR->P absent. PQ->R is present.
-- (1,2,3)(1,4,3) makes PR->Q absent. Two tuples with same PR but different Q.


-- Partial dependency necessary condition: A set G of attributes can determine all. Any proper subset of G can not determine all. However some proper subset of G can determine few (not all). 
-- Some attribute which is part of key can determine some (not all) attribute.
-- pqrs:1278,1356,4359,4256,
-- Here qs can determine all. No two tuples have same q and s both.
-- q alone can not determine all because second and third tuple have same q. 
-- s alone can not determine all because second and fourth tuple have same s.
-- However s alone can determine r. second and fourth tuple have same r also. s=6 means r=5.
-- ER diagram [attributes:r,s Key s]-----(attributes:p)-----[attributes:q]



-- Example 1: Attributes abcde key bc  ER:[attributes: a,b,c,d,e: key bc]
-- Let FD b->e and c->a also hold [attributes:a,c:key c]----(attributes:d)-------[attributes: b,e: Key b]
-- Example 2: In above b->e absent [attributes:a,c:key c]----(attributes:d,e)-------[attributes:b: Key b]
-- Example 3: Attributes abcde key bcd  FD b->e and cd->a  [attributes:a,c,d:key cd]----(attributes:)-------[attributes:b,e: Key b]




-- Key ab with no partial dependency (1,2,6)(1,4,6)(5,4,6)(5,2,7)
-- Key ab with  b->c                (1,2,6)(1,4,6)(5,4,6) It is partial
-- Key ab,ac,bc without any FD      (1,2,3)(1,4,6)(5,4,3)
-- Key ab,ac with b->c           (1,2,3)(1,4,6)(5,4,6)(5,8,3) But it is not partial because c itself is part of key.
-- Key ab,ac with b->c and c->b  (1,2,3)(1,4,6)(5,4,6)
-- Key abc                       (1,2,6)(1,4,6)(5,4,6)(1,2,7)
-- Key: ab with FD c->b not possible. In this case ac will also be key.
-- Key: ab, ac with c->b possible
-- Key: ab with FD a->b not possible. In this case a itself will be key.