-- Many One Relation
-- 
-- i     0     1     2     3     4     5     6     7     8     9    10     11
-- P    10     7     0   105   103    11   104   102     2     1     6    100
-- Q     5   101     9     4     8     3
-- 
-- Above represents binary relation 100:{5,11}  101:{}  102:{9,1,7}  103:{4}  104:{8,2,0,10,6} 105:{3}
-- 
-- Following represents binary relation 106:{2,0,7} 107:{1} 108:{11,4,6,3} 109:{5,8,10,9}
-- 
-- i     0     1     2     3     4     5     6     7     8     9    10    11
-- R     7	  107	  0	  108	  6 	8     3   106    10   109     9     4
-- Q                                         2     1    11     5
-- 
-- Both combined represent following
-- 
-- i     0     1     2     3     4     5     6     7     8     9    10    11
--     104	  102	104   105	103   100	104   102	104	  102	104	  100
--     106	  107	106	  108	108	  109	108	  106	109	  109	109	  108



-- OS	 Anil,Dipu,Gyan	    Yogesh	
-- CN	 Dipu,Hari	        Vinay	
-- LA	 Anil	            Umesh	
-- MA	 Hari,Gyan	        Vinay	
-- BE	 Lalit,Hari,Gyan	Umesh	
-- CN	 Gyan	            Suresh	
-- LA	 Lalit,Hari	        Umesh	
-- MA	                    Gopal	

-- Let CN has 2 sections. In one section Dipu and Hari are students. Teacher is vinay. In another section Gyan is student with teacher suresh.
-- LA has two sections. In both same teacher Umesh. 
-- MA has 2 sections. In one of the sections there is no student.


-- Write sql query for following. Use  method of exactly one of nested query, join, count, Union/Intersection/Except

-- 1: Which course was done by Dipu and Gyan by sitting in different section. CN
-- 2: Which course has same teacher in different sections LA
-- 3: In which section of which course there is no student.  MA 2
-- 4: Which course(s) has more than one section.
-- 5: Output courses in the increasing order of section. Initially BE,OS then CN,LA,MA

-- Solution
create table p (section int,course char(10),name char(10));
insert into p values (1,'OS','Anil'), (1,'OS','Dipu'),(1,'OS','Gyan'),(1,'CN','Dipu'),(1,'CN','Hari'),(1,'LA','Anil'), (1,'MA','Hari'), (1,'MA','Gyan'), (1,'BE','Lalit'),(1,'BE','Hari'),(1,'BE','Gyan'),(2,'CN','Gyan'),(2,'LA','Lalit'),(2,'LA','Hari');
create table q (section int,course char(10),teacher char(10));
insert into q values (1,'OS','Yogesh'), (1,'CN','Vinay'),(1,'LA','Umesh'), (1,'MA','Vinay'),(1,'BE','Umesh'),(2,'CN','Suresh'),(2,'LA','Umesh'),(2,'MA','Gopal');

-- Write sql query for following. Use  method of exactly one of nested query, join, count, Union/Intersection/Except

-- 1: Which course was done by Dipu and Gyan by sitting in different section. CN
select course from p where name='Dipu' and exists (select * from p as m where m.course=p.course and m.section!=p.section and m.name='Gyan'); 
select p.course from p as a,p where p.name='Dipu'and a.name='Gyan'and
p.course=a.course and p.section!=a.section;

-- 2: Which course has same teacher in different sections LA
select course from q where exists (select course from q as a where q.course=a.course and q.teacher=a.teacher and q.section!=a.section);
select q.course from q,q as y where q.course=y.course and q.secti
on!=y.section and q.teacher=y.teacher;
-- 3: In which section of which course there is no student.  MA 2
select course,section from q except select course,section from p;
select course,section from q where not exists (select * from p where q.course=p.course and q.section=p.section)
Do by join. No nested query or except

-- 4: Which course(s) has more than one section.
select distinct q.course from q,q as y where q.course=y.course and q.section!=y.section;
select distinct q.course from q where exists (select * from q as y where q.course=y.course and q.section!=y.section);
select course from q group by course having count(section)>1;

-- 5: Output courses in the increasing order of section. Initially BE,OS then CN,LA,MA
select course,count(section) from q group by course order by count(section) desc,course desc;
Remove decreasing at one of the above places
Delete count(section) from select but not from order by
order by course desc,count(section);


-- My Solution
-- Online SQL Editor to Run SQL Online.
-- Use the editor to create new tables, insert data and all other SQL operations.
 
drop table if exists p;

create table p (course char[2], student char[10], teacher char[10], section int);
insert into p values
("OS", "Anil", "Yogesh", 1),
("OS", "Dipu", "Yogesh", 1),
("OS", "Gyan", "Yogesh", 1),
("CN", "Dipu", "Vinay", 1),
("CN", "Hari", "Vinay", 1),
("LA", "Anil", "Umesh", 1),
("MA", "Hari", "Vinay", 1),
("MA", "Gyan", "Vinay", 1),
("BE", "Lalit", "Umesh", 1),
("BE", "Hari", "Umesh", 1),
("BE", "Gyan", "Umesh", 1),
("CN", "Gyan", "Suresh", 2),
("LA", "Lalit", "Umesh", 2),
("LA", "Hari", "Umesh", 2),
("MA", "", "Gopal", 2);

-- Write sql query for following. Use  method of exactly one of nested query, join, count, Union/Intersection/Except
-- 1: Which course was done by Dipu and Gyan by sitting in different section. CN
SELECT course
FROM p
WHERE student IN ('Dipu', 'Gyan')
GROUP BY course
HAVING COUNT(DISTINCT section) = 2;

-- 2: Which course has same teacher in different sections LA
SELECT course
FROM p
GROUP BY course, teacher
HAVING COUNT(DISTINCT section) > 1;

-- 3: In which section of which course there is no student.  MA 2
SELECT course, section
FROM p
WHERE student = "";

-- 4: Which course(s) has more than one section.
SELECT course
FROM p
GROUP BY course
HAVING COUNT(DISTINCT section) > 1;

-- 5: Output courses in the increasing order of section. Initially BE,OS then CN,LA,MA
SELECT course
FROM p
GROUP BY course
ORDER BY COUNT(DISTINCT section);

