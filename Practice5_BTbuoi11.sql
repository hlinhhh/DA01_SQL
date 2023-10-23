--baitap1
select country.continent,
floor(avg(city.population))
from country 
inner join city on country.code=city.countrycode
group by country.continent

--baitap2 --Bài này em không hiểu sao kết quả lại ra 0.00 => Anh/chị cho em hỏi phần sử dụng cast kia với ạ? Em cảm ơn ạ.
select 
round(cast(sum(case when signup_action = 'Confirmed' then 1 else 0 end)/
count(*) as decimal),2) as activation_rate
from emails
left join texts on texts.email_id = emails.email_id
where signup_action is not null

--baitap3 --Bài này em có search thêm phần "filter"
select b.age_bucket, 
round(100.0 * sum(a.time_spent) filter(where a.activity_type = 'send')/sum(a.time_spent),2) as send_perc, 
round(100.0 * sum(a.time_spent) filter(where a.activity_type = 'open')/sum(a.time_spent),2) as open_perc
from activities as a
inner join age_breakdown AS b on a.user_id = b.user_id 
where a.activity_type in ('send', 'open') 
group by b.age_bucket

--baitap4
select a.customer_id
from customer_contracts as a
left join products as b on a.product_id = b.product_id
group by a.customer_id
having count(distinct b.product_category) = 3

--baitap5 --Em đang không biết bài này bị sai ở đâu ạ, anh/chị giải đáp giúp em với nha ạ. Em cảm ơn ạ
select a.employee_id, a.name, 
count(b.reports_to) as reports_count,
ceiling(avg(b.age)) as average_age
from employees as a
left join employees as b on a.employee_id = b.reports_to
group by a.employee_id, a.name
having count(b.reports_to) <> 0
order by a.employee_id ASC

--baitap6
select a.product_name, 
sum(b.unit) as unit
from products as a
join orders as b on a.product_id = b.product_id
where extract(month from b.order_date) = 02 and extract(year from b.order_date) = 2020
group by a.product_name
having sum(b.unit) >=100

--baitap7
select a.page_id
from pages as a
left join page_likes as b on a.page_id = b.page_id
where b.page_id is null
order by b.page_id
