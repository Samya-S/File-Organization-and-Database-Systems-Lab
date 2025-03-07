-- Q1: In the table p(student char(7), course char(4), slot char(1)); 
--     write smallest query to change course of Lalit from KY to GD. 
--     Hint: Change slot also. Assume there is a person with new slot.

-- Solution:
Update p set course="GD",slot=(select slot from p where course="GD")  where student="Lalit" and course="KY";