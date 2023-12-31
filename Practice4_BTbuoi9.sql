--baitap1
select 
sum(case 
when device_type = 'laptop' then 1 
else 0 
end) as laptop_views, 
sum(case 
when device_type in ('tablet', 'phone') then 1 
else 0 
end) as mobile_views 
from viewership

--baitap2
select x, y, z,
case 
when (x+y>z) and (x+z>y) and (y+z>x) then 'Yes'
else 'No'
end as triangle
from triangle

--baitap3
select 
round(100.0 *
cast(sum(case when call_category = 'n/a' or call_category is null then 1
else 0
end)/count(call_category) as decimal),1)
from callers

--baitap4 
select name from customer
where coalesce (referee_id, '') <>2 

--baitap5
select 
survived,
sum(case
when pclass = 1 then 1
else 0
end) as first_class,
sum(case
when pclass = 2 then 1
else 0
end) as second_class,
sum(case
when pclass = 3 then 1
else 0
end) as third_class
from titanic
group by survived
