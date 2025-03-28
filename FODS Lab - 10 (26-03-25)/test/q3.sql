-- Q3: Output of following program is 7,4. Make minimum modifications in first line so that output is 7,9,4,8;  
--     Write complete line after modifications. 
create table m(k int);insert into m values (95),(4),(67),(7);--make minimum modifications in this line
create table u(k int);insert into u values (7),(9),(4),(8);
select k as y from u where exists (select * from m where y=k);

-- Solution: create table m(k int)  replace k by some other name but not y
