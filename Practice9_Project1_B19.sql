--1.
alter table public.sales_dataset_rfm_prj
alter column ordernumber type numeric using ordernumber::numeric
alter column quantityordered type numeric using quantityordered::numeric
alter column priceeach type numeric using priceeach::numeric
alter column orderlinenumber type numeric using orderlinenumber::numeric
alter column sales type numeric using sales::numeric
alter column msrp type numeric using msrp::numeric

alter table public.sales_dataset_rfm_prj
alter column orderdate type timestamp using orderdate::timestamp

--2: Không có giá trị null trong 6 cột cần check. Câu này em pending cách làm ạ.
select * from public.sales_dataset_rfm_prj
where ordernumber is null
or quantityordered is null
or priceeach is null
or orderlinenumber is null
or sales is null
or orderdate is null

--3: 
alter table public.sales_dataset_rfm_prj
add column contactlastname varchar(30)

update public.sales_dataset_rfm_prj
set contactlastname = substring(contactfullname from 1 for position('-' in contactfullname)-1)

update public.sales_dataset_rfm_prj
set contactlastname = upper(left(contactlastname, 1)) || substring(contactlastname from 2)

alter table public.sales_dataset_rfm_prj
add column contactfirstname varchar(30)

update public.sales_dataset_rfm_prj
set contactfirstname = substring(contactfullname from position('-' in contactfullname)+1)

update public.sales_dataset_rfm_prj
set contactfirstname = upper(left(contactfirstname, 1)) || substring(contactlastname from 2)

--4:
alter table public.sales_dataset_rfm_prj
add column qtr_id text
update public.sales_dataset_rfm_prj
set qtr_id = 
(case 
when extract(month from orderdate) in (1, 2, 3) then '1'
when extract(month from orderdate) in (4, 5, 6) then '2'
when extract(month from orderdate) in (7, 8, 9) then '3'
when extract(month from orderdate) in (10,11,12) then '4'
else '0'
end)

alter table public.sales_dataset_rfm_prj
add column month_id numeric
update public.sales_dataset_rfm_prj
set month_id = extract (month from orderdate)

alter table public.sales_dataset_rfm_prj
add column year_id numeric
update public.sales_dataset_rfm_prj
set year_id = extract (year from orderdate)

--5:
with cte as
(select Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value from 
(select 
 percentile_cont(0.25) within group (order by quantityordered) as Q1,
  percentile_cont(0.75) within group (order by quantityordered) as Q3,
 percentile_cont(0.75) within group (order by quantityordered) -
 percentile_cont(0.25) within group (order by quantityordered) as IQR
from public.sales_dataset_rfm_prj) as a)

select * from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from cte)
or quantityordered > (select max_value from cte)

=> 2 cách xử lý outliers:
C1: Dùng delete
delete from public.sales_dataset_rfm_prj
where quantityordered in 
(select quantityordered from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from cte)
or quantityordered > (select max_value from cte))

C2: Dùng update
update public.sales_dataset_rfm_prj
set quantityordered = (select avg(quantityordered) from public.sales_dataset_rfm_prj
					  where quantityordered in select quantityordered from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from cte)
or quantityordered > (select max_value from cte))

--6:
create table sales_dataset_rfm_prj_clean as
(select * from public.sales_dataset_rfm_prj)




