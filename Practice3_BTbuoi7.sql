--baitap1
select name from students
where marks >75
order by right(name,3) ASC, ID ASC

--baitap2
select user_id,
concat(upper(left(name,1)),lower(replace(name,left(name,1),''))) as name => Anh/chị cho em hỏi cú pháp này sai ở đâu vậy ạ? Khi em run thử thì accepted nhưng submit thì wrong ạ
from Users
order by user_id
/concat(upper(left(name,1)),lower(substring(name from 2))) as name => Anh/chị cho em hỏi được bỏ qua phần 'for' độ dài ký tự ạ?

--baitap3
select manufacturer,
concat('$', round(sum(total_sales)/1000000,0),' million') as sale
from pharmacy_sales
group by manufacturer
order by sum(total_sales) DESC, manufacturer ASC 

--baitap4
select extract (month from submit_date) as mth,
product_id as product,
round(avg(stars),2) as avg_stars
from reviews 
group by extract (month from submit_date), product_id
order by extract (month from submit_date), product_id

--baitap5
select sender_id,
count(sender_id) as message_count
from messages
where sent_date between '07/31/2022' and '09/01/2022'
group by sender_id
order by count(sender_id) DESC
limit 2

--baitap6
select
tweet_id
from Tweets
where length(content) >15

--baitap7

--baitap8
select count(id) as the_number_of_employees_hired
from employees
where joining_date between '2021-12-31' and '2022-08-01'

--baitap9
select 
position ('a' in 'Amitah')
from worker
where first_name = 'Amitah'

--baitap10
