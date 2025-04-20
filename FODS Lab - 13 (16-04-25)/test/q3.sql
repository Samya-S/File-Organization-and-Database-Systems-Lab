-- Q3: Define smallest trigger. Do not use any number bigger than 20 in the definition. Use only one update.
create table p (a int,b int);
insert into p values (132,17);
-- create trigger m  ......
 
insert into p values (2,4),(7,9),(5,6);
select * from p;--output (269,1190)(2,4)(55,45)(5,6)

-- Solution:
create trigger m before insert on p
  begin
       update p set a=a+7*new.a+13,b=b*new.a where a>6; --in place of 6 one may use 2-6
  end;