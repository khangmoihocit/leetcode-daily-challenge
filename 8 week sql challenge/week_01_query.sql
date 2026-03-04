/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
use dannys_diner;
select * from menu;
select * from sales;
select * from members;

select s.customer_id, sum(mn.price) as total
from sales s
					join menu mn on s.product_id = mn.product_id
group by s.customer_id;
       
-- 2. How many days has each customer visited the restaurant?
select s.customer_id, count(distinct date(s.order_date)) as total_days
from sales s
group by s.customer_id;

-- 3. What was the first item from the menu purchased by each customer?
select s.customer_id, m.product_name
from sales s, menu m
where s.product_id = m.product_id
and s.order_date = (
			select min(s2.order_date)
				from sales s2 where s2.customer_id = s.customer_id);


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select count(s.product_id) as total_product, m.product_name
from sales s, menu m
where s.product_id = m.product_id
group by s.product_id, m.product_name
order by count(s.product_id) DESC limit 1;

SELECT s.customer_id, m.product_name, COUNT(s.product_id) as order_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
WHERE s.product_id = (
    -- Subquery tìm ID của món được mua nhiều nhất
    SELECT product_id FROM sales 
    GROUP BY product_id 
    ORDER BY COUNT(product_id) DESC LIMIT 1
)
GROUP BY s.customer_id, m.product_name;

-- 5. Which item was the most popular for each customer?
select count(s.product_id) as total_product, mn.product_name, mb.customer_id 
from sales s join menu mn on s.product_id = mn.product_id
				join members mb on s.customer_id = mb.customer_id
group by s.product_id, mn.product_name, mb.customer_id
order by count(s.product_id) DESC limit 1;

-- 6. Which item was purchased first by the customer after they became a member?
select s.product_id, s.order_date, m.customer_id
from sales s, members m
where s.customer_id = m.customer_id
and s.order_date in (select sales.order_date from sales 
                    where sales.customer_id = s.customer_id 
                    and sales.order_date >= m.join_date
                    order by sales.order_date ASC limit 1);

      create view ranked_sales AS (
    SELECT s.customer_id, m.product_name, s.order_date,
           DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) as rank
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
)
SELECT customer_id, product_name 
FROM ranked_sales 
WHERE rank = 1;                  
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
