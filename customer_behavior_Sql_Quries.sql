use sand;
CREATE TABLE customer_behaviour (
    customer_id int,
    age int,
    gender VARCHAR(30),
    item_purchased VARCHAR(40),
    category VARCHAR(40),
    purchase_amount int,
    location VARCHAR(40),
    product_size VARCHAR(10),
    color VARCHAR(40),
    season VARCHAR(40),
    review_rating float,
    subscription_status VARCHAR(10),
    shipping_type VARCHAR(40),
    discount_applied VARCHAR(10),
    previous_purchases int,
    payment_method VARCHAR(40),
    frequency_of_purchases VARCHAR(40),
    age_group VARCHAR(40),
    purchase_frequency_days int
);

select * from customer_behaviour;

select gender,sum(purchase_amount) as total_revenue from customer_behaviour
group by gender;

select customer_id,purchase_amount from customer_behaviour
where discount_applied = 'yes' and purchase_amount >(select avg(purchase_amount) from customer_behaviour);

select item_purchased,round(avg(review_rating),2) as avg_review_rating from customer_behaviour
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type , round(avg(purchase_amount),2) from customer_behaviour
where shipping_type in ('Standard','Express')
group by shipping_type;

select subscription_status,
count(customer_id) as total_customer,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue from customer_behaviour
group by subscription_status
order by total_revenue,avg_spend desc;

select item_purchased,
round(100* sum(case when discount_applied ='Yes' then 1 else 0 end) / count(*),2) as discount_rate
from customer_behaviour
group by item_purchased
order by discount_rate desc
limit 5;

with customer_type as(
select customer_id,previous_purchases,
case
when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer_behaviour
)

select customer_segment,count(*) as "No of customers"
from customer_type
group by customer_segment;

with item_count as (
select category,
item_purchased,
count(customer_id) as total_order,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer_behaviour
group by category,item_purchased)

select item_rank,category,item_purchased from item_count
where item_rank<=3;

select subscription_status, count(customer_id) as repeat_buyers
from customer_behaviour
where previous_purchases >5
group by subscription_status;

select age_group,sum(purchase_amount) as total_revenue
from customer_behaviour
group by age_group
order by total_revenue desc;


