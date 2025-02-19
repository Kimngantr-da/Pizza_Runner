# Pizza Metrics 
--How many pizzas were ordered?
select
count(*) as orders
from customer_orders

--How many unique customer orders were made?
select
count(distinct customer_id) as customers
from customer_orders

-- How many successful orders were delivered by each runner?
select
runner_id,
count(*) as successful_orders
from runner_orders
where cancellation IS NULL
Group by 1

--How many of each type of pizza was delivered?
select
pizza_id,
count(order_id) as delivered_quantity
from customer_orders c
join runner_orders r
on c.order_id=r.order_id
where cancellation IS NULL
group by 1

--How many Vegetarian and Meatlovers were ordered by each customer?
select 
c.customer_id,
p.pizza_id,
count(*) as quantity
from customer_order as c
left join pizza_names as p
on c.pizza_id=p.pizza_id
group by 1,2

-- What was the maximum number of pizzas delivered in a single order?
select
order_id,
count(pizza_id) as quantity
from customer_orders c
left join runner_orders r
on c.order_id=r.order_id
where r.cancellation is NULL
group by 1
order by 2 desc
limit 1

--7,8
With base as (
select
customer_id,
pizza_id,
case
when exclusions is NULL and extras is NULL then 'no change'
when exclusions is not NULL AND extras is not NULL then 'both change'
else 'at least 1 change'
end as change
from customer_orders c
left join runner_orders r
on c.order_id=r.order_id
where r.cancellation is NULL
group by 1,2,3)

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select 
customer_id,
change,
count(pizza_id) as quantity
from base
where change IN ('at least 1 change','no change')
group by 1,2

--How many pizzas were delivered that had both exclusions and extras?
select
count(pizza_id) as both_exclusions_and_extras
from base
where change IN ('both change')

--What was the total volume of pizzas ordered for each hour of the day?
select
DATE_TRUNC(order_date,hour) as hours
count(pizza_id) as volume_of_pizza
from customer_orders
group by 1

--What was the volume of orders for each day of the week?
select
FORMAT_DATE('%A',order_date) as dow,
count(order_id) as volume_of_orders
from customer_orders c
left join runner_orders r
on c.order_id=r.order_id
where r.cancellation is NULL
group by 1



