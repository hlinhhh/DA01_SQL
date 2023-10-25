--baitap4
select a.page_id
from pages as a
left join page_likes as b on a.page_id = b.page_id
group by a.page_id
having count(b.user_id) = 0
order by a.page_id 
//hoặc:
select page_id from pages
where page_id not in (select page_id from page_likes)
order by page_id

--baitap5
with bb as 
(select  user_id from user_actions 
where extract(month from event_date) in (6,7) 
and extract(year from event_date) = 2022 
group by user_id 
having count(distinct extract(month from event_date)) = 2)
select 7 as month, count(user_id) as monthly_active_users 
from bb 

--baitap6: Em đang làm như này thì web báo lệnh to_char bị lỗi ạ.
with bb as
(select id, count(id) as trans_count, sum(amount) as trans_total_amount
from Transactions
group by id),
bb2 as
(select id, count(id) as approved_count, sum(amount) as approved_total_amount
from Transactions
where state = 'approved'
group by id)
select to_char (a.trans_date,'yyyy-mm') as month, a.country, b.trans_count, c.approved_count, b.trans_total_amount, c.approved_total_amount
from Transactions as a
join bb as b on a.id = b.id
join bb2 as c on a.id = c.id

--baitap7
select product_id, year as first_year, quantity, price
from Sales
where (product_id, year) in (select product_id, min(year) from Sales
group by product_id)

--baitap8
select customer_id from customer 
group by customer_id
having count(distinct product_key) = (select count(product_key) from product)

--baitap9
select employee_id from Employees as a
where manager_id not in (select employee_id from employees) 
and salary < 30000
order by employee_id 

--baitap10
select count(distinct company_id) as duplicate_companies
from (select company_id, count(job_id) as count_jobs from job_listings
group by company_id) as duplicate_count
where count_jobs > 1
