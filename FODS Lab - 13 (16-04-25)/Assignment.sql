-- Every node stores 2 or 3 element
-- 
-- (12,17,19)(22,42)(47,50,67)(80,94)(97,98)
-- 
-- Insert 41: (12,17,19)(22,41,42)(47,50,67)(80,94)(97,98)
-- 
-- Insert 49: (12,17,19)(22,42)(47,49)(50,67)(80,94)(97,98) [Split when 4 elements  (47,49,50,67) is formed it is broken in 2-2] 
-- 
-- Delete 50:(12,17,19)(22,42)(47,67)(80,94)(97,98)
-- 
-- Delete 98:(12,17,19)(22,42)(47,50,67)(80,94,97) [When under load then share with neighbor]
-- 
-- When total elements less than 3 then merge else transfer.
-- 
-- Delete 94:(12,17,19)(22,42)(47,50)(67,80)(97,98)  or (12,17,19)(22,42)(47,50,67)(80,97,98)




-- B+ tree   Every node has 2/3 elements/pointers.
-- 
-- root:m:(u23p) u:(12,17)  p:(25,27,34)
-- 
-- It means [(u:12,17)23(p:25,27,34)]. Elements less than 23 are in u and bigger than 23 in p.
-- 
-- Insert 22. It will be inserted in u since 22<23  [(u:12,17,22)23(p:25,27,34)].
-- 
-- root:m:(u23p) u:(12,17,22)  p:(25,27,34)

------------------------------------------------------

-- root:m:(u23p) u:(12,17)  p:(25,27,34)
-- 
-- Insert 24. It will be inserted in p since 24>23. [(u:12,17)23(p:24,25,27,34)].
-- 
-- Since node p has 4 elements hence one extra node y is taken. (p:24,25)(y:27,34) Some intermediate element between 25 and 27 (say 26) is put between them. [(u:12,17)23(p:24,25)26(y:27,34)].
-- 
-- root:(u23p26y) u:(12,17)  p:(24,25)  y:(27,34)

--------------------------------------------

-- root:m:(u23p) u:(12,17)  p:(25,27,34)  [(u:12,17)23(p:25,27,34)].
-- 
-- Delete 17  [(u:12)23(p:25,27,34)] Node u has only one element. It should have at least 2. Hence one element from p is transferred.
-- 
--  [(u:12,25)26(p:27,34)] Some intermediate element between 25 and 27 is put.
-- 
-- root:m:(u26p) u:(12,25)  p:(27,34) 

-------------------------------------------

-- root:(u23p26y) u:(12,17)  p:(24,25)  y:(27,34)   [(u:12,17)23(p:24,25)26(y:27,34)]
-- 
-- Delete 17. [(u:12)23(p:24,25)26(y:27,34)]
-- 
-- Node u has only one element. If an element from p is transferred then p will have only one element.
-- 
-- Hence the remaining element of u is transferred to p. Node u is deleted.
-- 
-- [(p:12,24,25)26(y:27,34)]
-- 
-- root:(p26y)  p:(12,24,25)  y:(27,34)

--------------------------------------------

-- root:m:(u23p28y) u:(12,17)  p:(25,27)  y:(29,34)
-- 
-- delete 27 root:(u23y) u:(12,17) y:(25,29,34)  or  root:(u28y) u:(12,17,25)  y:(29,34)

-----------------------------------------------

-- root:m:(u23p) u:(12,17)  p:(25,27) 
-- 
-- It means  [(u:12,17) (p:25,27)] delete 27 [(u:12,17,25)]  free node p
-- 
-- root:m:(u) u:(12,17,25) 
-- 
-- Here m has only one pointer. Hence u itself is made root. free m also
-- 
-- root: u:(12,17,25) 

---------------------------------------------

-- root:u:(12,17,27) insert 25  u:(12,17,25,27)
-- 
-- u has 4 elements. Hence a new node p is taken. u:(12,17) p:(25,27)
-- 
-- Another new node m is taken to link u and p.
-- 
-- root:m:(u23p) u:(12,17)  p:(25,27)

-----------------------------------------------

-- root:m:(u23p28y) u:(12,17,21)  p:(25,27) y:(29,34)
-- 
-- Inert 19 m:(u23p28y) u:(12,17,19,21)  p:(25,27) y:(29,34)  u is split into two parts. Another node h is taken.
-- 
--  m:(u18h23p28y) u:(12,17) h:(19,21)  p:(25,27) y:(29,34)
-- 
-- Here node m has 4 pointers u,h,p,y. Hence a new node d is taken. It will take 2 pointers.  m: (u18h)  d:(p28y) 
-- 
-- A new node links m and d. (m23d) 
-- 
-- it changes to root:k:(m23d) m:(u18h) d:(p28y)  u:(12,17) h(19,21)  p:(25,27) y:(29,34)

-----------------------------------------------

-- root:k:(m23d) m:(u18h) d:(p28y40w) u:(12,17) h:(19,21)  p:(25,27) y:(29,34) w:(50,60)
-- 
-- It means elements less then 23 are in m. Elements more than 23 in d.
-- 
-- m[(u:12,17) (h:19,21)]  d[(p:25,27)  (y:29,34) (w:50,60)]
-- 
-- Delete 12 m[(u:17) (h:19,21)] u has only one element 17 hence it is transferred to h.
-- 
-- m[(h:17,19,21)]  d[(p:25,27)  (y:29,34) (w:50,60)] 
-- 
-- Node m has only one pointer h. Node d has three pointers p,y,w.
-- 
-- Hence one pointer is transferred from d to m
-- 
-- m[(h:17,19,21) (p:25,27)]    d[(y:29,34) (w:50,60)]   
-- 
-- Elements less than 28 are in m. Hence k changes to (m28d).
-- 
-- root:k:(m28d)  m:(h23p)  d:(y40w) h:(17,19,21) p:(25,27) y:(29,34) w:(50,60)

-----------------------------------------------

-- root:k:(m23d) m:(u18h) d:(p28y) u:(12,17) h(19,21)  p:(25,27) y:(29,34) 
-- 
-- m[(u:12,17) (h:19,21)]  d[(p:25,27)  (y:29,34)]
-- 
-- delete 34 m[(u:12,17) (h:19,21)]  d[(p:25,27)  (y:29)]
-- 
-- m[(u:12,17) (h:19,21)]  d[(p:25,27,29)]  free d
-- m[(u:12,17) (h:19,21)]  (p:25,27,29)
-- m[(u:12,17) (h:19,21) (p:25,27,29)]
-- root m:(u18h23p) u:(12,17) h(19,21)  p:(25,27,29)
-- 
-- Important: During insert split (if needed). No load transfer.
-- 
-- During delete node merge or load transfer  with previous node (if exists) or next node (if exists)

-----------------------------------------------

-- Following stores information 12,18,23,  34,40,  56,61,63,  78,82,84,  90,93,
-- 
-- i       0     1     2     3     4     5     6    In    0     1     2     3     4     5     6     7
-- a[i]  500    78    34          12    90    56    Se  500    78    34          12    90    56    82
-- b[i]         82    40          18    93    61    Rt         81    40          18    93    61    84
-- c[i]         84                23          63    81                           23          63
-- z[i]    4     5     6           2     0     1          4     7     6           2     0     1     5


-- #include<stdio.h>
-- 
-- int a[]={500,78,34,00,12,90,56,0,0,0,0};
-- 
-- int b[]={500,82,40,00,18,93,61,0,0,0,0};
-- 
-- int c[]={500,84,99,00,23,99,63,0,0,0,0};
-- 
-- int z[]={4,5,6,0,2,0,1,0,0,0,0};
-- 
-- int free=7;
-- 
-- void print()
-- {
--     int i=z[0];
-- 
--     while(i!=0) { printf("  %d,%d,",a[i],b[i]); if(c[i]<99) printf("%d,",c[i]); i=z[i];}
-- 
-- }
-- 
-- void search()
-- {   
--     int x,i;scanf("%d",&x);
-- 
--     i=0;while(a[z[i]]<=x){printf("%d;",a[i]);i=z[i];}
-- 
--     if((a[i]==x)||(b[i]==x)||(c[i]==x))  printf("present"); else printf("absent");
-- }
-- 
-- void ex(int *a,int *b) {  int t;t=*a;*a=*b;*b=t; }
-- 
-- void insert()
-- { 
--     int i,x,p,q,r;  scanf("%d",&x);
-- 
--     i=0;while(a[z[i]]<x) i=z[i];
-- 
--     p=a[i];q=b[i];r=c[i];if(x<r) ex(&x,&r); if(r<q) ex(&q,&r); if(q<p) ex(&p,&q);
-- 
--     a[i]=p;b[i]=q;if(x==99) c[i]=r;
-- 
--     else {z[free]=z[i];z[i]=free;a[free]=r;b[free]=x;c[free]=99;c[i]=99;free++;}
-- }
-- 
-- void del()
-- {  
--     int i,x,p,q,r; 
--     scanf("%d",&x);
--     i=0;
--     while(a[z[i]]<=x) i=z[i];
--     p=a[i];q=b[i];r=c[i];
--     if(p==x) p=99;if(q==x)q=99;if(r==x)r=99;
-- 
--     if(q<p) ex(&p,&q); 
--     if(r<q) ex(&q,&r); 
-- 
--     a[i]=p;b[i]=q;c[i]=99;
-- 
--     if(q==99)
--         if (c[z[i]]==99){ b[i]=a[z[i]]; c[i]=b[z[i]]; z[i]=z[z[i]]; }
--         else { b[i]=a[z[i]]; a[z[i]]=b[z[i]]; b[z[i]]=c[z[i]]; c[z[i]]=99; }
-- }
-- 
-- main()
-- { 
--     int i,x;
--     while(1)
--     {  
--         scanf("%d",&x);
--         if(x==0) print();     if(x==1) search();     if(x==2) insert();     if(x==3) del();
--     }
-- }


create table p (a int,b int,c int);
insert into p values (2,7,1),(5,9,4),(7,3,6),(2,11,1);
create trigger m after insert on P for each row
  begin
    update p set a=a+1 where a<10;
  end;
insert into p values (2,4,1);
select * from p;
-- replace after by before

create table p (r int,d int);
insert into p values (2,7),(5,9),(7,3),(2,11);
create trigger m before delete on P for each row
    begin
      insert into p values ((select max(r) from p),4);
      update p set d=r+2 where d=4;
   end;
delete from p where r=5;
select * from p;

-- Every Course has only one teacher. A student can take multiple courses.
create table p (student,course,teacher);
insert into p values ('Anil','PH','Jalaj'),('Dipu','MA','Kapil'),('Gyan','PH','Jalaj'),('Hari','CH','Lalit'),('Ravi','EN','Kapil');
create trigger m .....

insert into p values ('Anil','CH','nil');
select * from p;
-- Make suitable trigger so that following is output
-- student	course	teacher
-- Anil	      PH	Jalaj
-- Dipu	      MA	Kapil
-- Gyan	      PH	Jalaj
-- Hari	      CH	Lalit
-- Ravi	      EN	Kapil
-- Anil	      CH	Lalit

create table p (student,course,teacher);
insert into p values ('Anil','PH','Jalaj'),('Dipu','MA','Kapil'),('Gyan','PH','Jalaj'),('Hari','CH','Lalit'),('Ravi','EN','Kapil');
-- create trigger .....

insert into p values ('Anil','UV','nil');
insert into p values ('Ravi','UV','Gopal');
select * from p;

-- Make suitable trigger so that following is output
-- student	course	teacher
-- Anil	      PH	Jalaj
-- Dipu	      MA	Kapil
-- Gyan	      PH	Jalaj
-- Hari	      CH	Lalit
-- Ravi	      EN	Kapil
-- Anil	      UV	Gopal
-- Ravi	      UV	Gopal


create table p (student,course);
create table q (course,teacher);
create table r (student,course,teacher,primary key(student,teacher));
insert into q values ('PH','Jalaj'),('MA','Kapil'),('CH','Lalit'),('EN','Jalaj');
create trigger m after insert on P for each row
begin
    insert into r values (new.student,new.course,(select teacher from q where course=new.course));
end;
insert into p values ('Anil','PH'),('Dipu','MA'),('Gyan','PH'),('Hari','CH'),('Anil','CH'),('Ravi','EN');
select * from r;
--insert into p values ('Anil','EN');

-- Make suitable trigger so that when course of Anil is updated from PH to EN then no error. From CH to EN is error. CH to MA no error.
create trigger u after update on P for each row
begin
    update r set course=new.course,teacher=(select teacher from q where course=new.course) where student=new.student and course=old.course;
end;
update p set course='EN' where student='Anil' and course='CH';