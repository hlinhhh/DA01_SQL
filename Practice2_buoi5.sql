--baitap1
select distinct city from station
where id%2=0

--baitap2
select
count(city) - count(distinct city)
from station

--baitap3: menh de replace(truong_thong_tin,'ky_tu_can_thay_the','ky_tu_thay_the') kaka cai nay em tra mang duoc a
select
ceiling(avg(salary)-avg(replace(salary,'0','')))
from employees

--baitap4: hieu cach giai thui nhung em khong viet duoc cu phap
  
--baitap5
select candidate_id
from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by (candidate_id)
having count(skill)=3
order by (candidate_id) ASC

--baitap6: em khong biet chuyen qua so ngay kieu gi a hic

--baitap7
select card_name, 
max(issued_amount) - min(issued_amount) as difference 
from monthly_cards_issued
group by (card_name)
order by (difference) DESC;

--baitap8
select manufacturer,
count (drug) as drug_count, 
sum(cogs - total_sales) as total_loss
from pharmacy_sales
where cogs > total_sales
group by manufacturer
order by total_loss DESC;

--baitap9
select * from cinema
where id%2=1
and not description like 'boring'
order by (rating) DESC

--baitap10
select teacher_id, 
count(distinct subject_id) as cnt
from teacher
group by teacher_id
  
--baitap11
select user_id,
count(follower_id) as followers_count
from followers
group by user_id
order by (user_id) ASC

--baitap12
select class from courses
group by (class)
having count(class)>=5

