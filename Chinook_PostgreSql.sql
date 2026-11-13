-- Q1: How many customers are there in total?
select count(*) as total_customer from customer;

-- Q2:Which countries do the customers come from?
select distinct country from customer order by country;

-- Q3: Which tracks cost more than $1?
select name , unit_price from track 
where unit_price >1;

-- Q4: How many customers are there in each country?
select country , count(*) as total_customers
from customer 
group by country order by country desc;

-- Q5: What is the total revenue for each country?
select billing_country as Country,
sum(total) as Total_revenue From invoice
group by billing_country order by Total_revenue desc;

-- Q6: How many tracks are there in each genre?
select g.genre_id , count(t.track_id) as total_tracks
from track t join genre g on t.genre_id = g.genre_id
group by g.genre_id order by total_tracks desc;

-- Q7: Who are the top 10 customers by total spending?
select c.first_name , c.last_name, c.country , sum(i.total) as Total_spent
from customer c join invoice i on c.customer_id = i.customer_id
group by c.customer_id order by Total_spent desc
limit 10;

-- Q8: What are the 10 best-selling tracks?
select t.name , sum(il.quantity) as best_selling 
from track t join invoice_line il on t.track_id = il.track_id
group by t.track_id
order by best_selling desc
limit 10;

-- Q9: What are the total sales for each genre?
select g.name , sum(il.unit_price * il.quantity) as total_sale
from invoice_line il join track t on il.track_id = t.track_id
join genre g on g.genre_id  = t.genre_id
group by g.name
order by total_sale desc;

-- Q10: What is the monthly revenue?

select date_trunc('month' , invoice_date) as Month,
sum(total) as revenue from invoice group by month
order by month desc;

-- Q11: Which customers spent more than the average customer? (subquery)
select c.first_name , c.last_name , sum(i.total) as total_spent
from customer c join invoice i on c.customer_id = i.customer_id
group by c.customer_id 
having sum (i.total) > (
select avg(customer_total)
from (
select sum(total) as customer_total
from invoice group by customer_id
) as total
)
order by total_spent desc;

-- Q12: Who is the top customer in each country? (window function)

with customer_spending as(
select c.first_name, c.last_name, c.country, sum(i.total) as total_spent
from customer c join invoice i on c.customer_id = i.customer_id
group by c.customer_id

),
ranked as (
select *, rank() over(partition by country order by total_spent desc)
as rnk from customer_spending
)

select first_name , last_name , country , total_spent
from ranked 
where rnk = 1
order by total_spent desc;

-- Q13: What is the running total of revenue over time? (CTE + window function)
with monthly_revenue as (
select date_trunc('month', invoice_date) as Month, 
sum(total) as revenue from invoice group by month
)

select month,
revenue, sum(revenue) over (order by month ) as running_total
from monthly_revenue order by month;
















































