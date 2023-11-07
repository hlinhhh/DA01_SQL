-1-
- Số lượng khách hàng và số lượng đơn hàng mỗi tháng nhìn chung đều tăng lên theo thời gian (ngoại trừ T1/2021 sang T2/2021)
- Từ T1/2019 đến T3/2019: số KH = số đơn hàng, nhưng từ T4/2019 đến T4/2022: số đơn hàng luôn lớn hơn số KH => có những KH mua nhiều hơn 1 đơn hàng trong 1 tháng. 
  => Có thể do chất lượng sản phẩm tốt/ các dịch vụ CSKH, đặc biệt sau mua tốt
SELECT
  FORMAT_DATE('%Y-%m', DATE (created_at)) as month_year,
  COUNT(DISTINCT user_id) AS total_user,
  COUNT(order_id) AS total_order
FROM
  bigquery-public-data.thelook_ecommerce.orders
WHERE
  created_at BETWEEN '2019-01-01'
  AND '2022-04-30'
GROUP BY
  1
ORDER BY 1

hoặc
with cte as(
select extract(year from created_at) as year, extract(month from created_at) as month,
count(user_id) as total_user, 
count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
where created_at between '2019-01-01' and '2022-05-01'
group by 1,2
order by 1,2)
select year||'-' ||month as year_month, total_user,total_order
from cte

-2- 
- Số lượng khách hàng nhìn chung đều tăng lên theo thời gian (có ngoại lệ một số tháng)
- Phần liên quan đến giá trị đơn hàng trung bình em chưa rõ insights lắm -
with cte as(
select extract(year from created_at) as year, 
extract(month from created_at) as month,
count(distinct user_id) as distinct_users, 
sum(sale_price)/count(order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01' and '2022-05-01'
group by 1,2
order by 1,2)
select year||'-' ||month as year_month, distinct_users,average_order_value
from cte

-3- Bài này em chưa biết dùng Union như nào ạ, phần đếm số người 12 tuổi và 70 tuổi em chưa nối lại được
- Trẻ nhất: 12 tuổi (1176 người), Cao tuổi nhất: 70 tuổi (1131 người)
with cte as (
select first_name, last_name, gender, age
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2018-12-31' and '2022-05-01'
and (age in (select min(age) as min_age
from bigquery-public-data.thelook_ecommerce.users) or age in (select max(age) as max_age
from bigquery-public-data.thelook_ecommerce.users))), 
cte_2 as (
select first_name, last_name, gender, age, 
case when age in (select min(age) as min_age
from bigquery-public-data.thelook_ecommerce.users) then 'youngest' else 'oldest' end as tag,
from cte)

select count(tag) from cte_2
where tag = 'youngest'

select count(tag) from cte_2
where tag = 'oldest'

-4-
with cte as (
select 
FORMAT_DATE('%Y-%m', DATE (a.created_at)) as month_year,
a.product_id, b.name as product_name, a.sale_price, b.cost, a.sale_price - b.cost as profit,
from  bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b on a.product_id = b.id
order by FORMAT_DATE('%Y-%m', DATE (a.created_at)) ASC),
cte_2 as (
select *,
dense_rank() over(partition by month_year order by profit DESC) as rank_profit
 from cte)
 select * from cte_2 
 where rank_profit < 6
 order by month_year ASC

-5-
with cte as (
select DATE (a.created_at) as dates, b.category as product_categories, a.sale_price - b.cost as profit
 from bigquery-public-data.thelook_ecommerce.order_items as a
 join bigquery-public-data.thelook_ecommerce.products as b on a.product_id = b.id
where DATE (a.created_at) between '2022-01-15' and '2022-04-15'
order by DATE (a.created_at) ASC)
select dates, product_categories, sum(profit) as revenue
from cte
group by dates, product_categories
order by dates ASC





