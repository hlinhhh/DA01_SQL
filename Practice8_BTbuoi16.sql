--baitap1: Kết quả của câu lệnh này không ra gì anh/chị ơi :(((. Anh/chị cmt giúp em với ạ
with twt_bb as
(select * from 
(select customer_id,
row_number() over(partition by customer_id order by order_date) as stt
from Delivery) as a
where stt=1),
twt_bb2 as
(select customer_id, count(stt) as total_first_order from twt_bb),
twt_bb3 as
(select count(customer_pref_delivery_date) as immediate_order,
customer_id from Delivery
where customer_pref_delivery_date = order_date)
select 
round((100* (b.immediate_order/a.total_first_order)),2) as immediate_percentage 
from twt_bb2 as a join twt_bb3 as b on a.customer_id = b.customer_id

--baitap2

--baitap3
select id, 
case 
when id%2=1 then coalesce (lead(student) over(order by id), student) 
else lag(student) over (order by id) 
end as student 
from seat

--baitap4: Kết quả báo em vẫn sai, có phải do phần extract kia không ạ?
with a as
(select visited_on, sum(amount) as day_sum from Customer group by visited_on), 
b as
(select visited_on, sum(amount) as day_sum from Customer group by visited_on) 
select 
a.visited_on as visited_on, 
sum(b.day_sum) as amount,
round(sum(b.day_sum)/7, 2) as average_amount
from a, b
where extract(day from a.visited_on) - extract(day from b.visited_on) between 0 and 6 
and a.visited_on - 6 >= (select min(visited_on) from Customer)
group by a.visited_on
order by a.visited_on

--baitap5
select round(sum(tiv_2016), 2) as tiv_2016
from
(select *, 
count(*) over (partition by tiv_2015) as tiv_2015_2, 
count(*) over (partition by lat, lon) as location
from Insurance) as a
where tiv_2015_2 > 1 and location = 1

