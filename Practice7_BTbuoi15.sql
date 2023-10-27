--baitap1
select 
extract (year from transaction_date) as year,
product_id,
spend as curr_year_spend,
lag(spend) over(PARTITION BY product_id order by transaction_date) as prev_year_spend,
round((((spend)-lag(spend) over(PARTITION BY product_id order by transaction_date))/
lag(spend) over(PARTITION BY product_id order by transaction_date) )*100,2)
from user_transactions 

--baitap2
select distinct
card_name,
first_value(issued_amount) over(PARTITION BY card_name order by issue_year, issue_month) as issued_amount
from monthly_cards_issued
order by issued_amount DESC

--baitap3
select user_id, spend, transaction_date from 
(select user_id, spend, transaction_date,
row_number() over(PARTITION BY user_id order by transaction_date ASC) as no
from transactions) as a
where a.no=3

--baitap4
select transaction_date, user_id,
count(transaction_date) as purchase_count
from (select *,
rank() over(PARTITION BY user_id order by transaction_date DESC)
from user_transactions
order by user_id,transaction_date DESC) as a
where rank=1
group by user_id,transaction_date
order by transaction_date

--baitap5: Bài này em không hiểu đề lắm, em làm theo ý hiểu là lấy kết quả TB của 3 ngày liên tiếp nhau nhưng mà hệ thống báo sai ạ
with twt_bb as  
(select *,
lag(tweet_count) over(PARTITION BY user_id order by tweet_date) as prev_1,
lag(tweet_count, 2) over(PARTITION BY user_id order by tweet_date) as prev_2
from tweets)
select user_id, tweet_date,
round((tweet_count + prev_1 + prev_2)/3, 2) as rolling_avg_3d
from twt_bb
where prev_1 is not null and prev_2 is not null

--baitap6: Anh/chị check giúp em phần lỗi sai của bài này với ạ
with twt_bb as 
(select merchant_id, 
extract(minute from transaction_timestamp - lag(transaction_timestamp) over(PARTITION BY merchant_id, credit_card_id, amount order by transaction_timestamp)) as diff
from transactions) 
select count(merchant_id) as payment_count
from twt_bb 
where diff <=10
  
--baitap7
with twt_bb as 
(select product, category, 
sum(spend) as total_spend, 
row_number() over(PARTITION BY category order by sum(spend) DESC) as rank 
from product_spend
where extract(year from transaction_date) = '2022'
group by product, category)
select category, product, total_spend from twt_bb
where rank <=2

--baitap8: em chạy kết quả thì có phần tên của Adele với Ed Sheeran khác với expected output, nhưng không biết chỉnh như thế nào ạ.
with twt_bb as 
(select a.artist_id, a.artist_name, 
count(c.song_id) as count
from artists as a 
join songs as b on a.artist_id = b.artist_id
join global_song_rank as c on b.song_id = c.song_id
where rank between 1 and 10
group by a.artist_id, a.artist_name)
select artist_name, artist_rank
from (select artist_name, 
dense_rank() over(order by count DESC) as artist_rank
from twt_bb) as d
where artist_rank <=5
