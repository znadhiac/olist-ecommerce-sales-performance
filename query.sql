-- ======================================================
-- OLIST E-COMMERCE SALES PERFORMANCE ANALYSIS
-- Queries to answer key business questions
-- Author: Zulfi Nadhia Cahyani
-- ======================================================

USE olist_copy;
SHOW TABLES;

-- =================================
-- 1. Sales and Revenue Performance
-- =================================

-- 1.1 Total orders and total revenue per month

-- Purpose:
-- Analyze monthly sales performance by counting total orders
-- and summing product prices to measure revenue trends over time.

SELECT 	MONTH(o.order_purchase_timestamp) AS month,
		MONTHNAME(o.order_purchase_timestamp) AS month_name,
		COUNT(DISTINCT(o.order_id)) AS total_order,
		SUM(oi.price) AS total_revenue
FROM orders o 
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY month, month_name
ORDER BY month;

-- Notes:
-- - Revenue is calculated using order_items.price
-- - Aggregated at month level based on order purchase date


-- 1.2 Top product categories by revenue and order count

-- Purpose:
-- Identify best-performing product categories based on total revenue and number of orders.

SELECT 	pc.product_category_name_english AS product_category, 
		COUNT(DISTINCT(o.order_id)) AS total_order,
		SUM(oi.price) AS total_revenue    
	FROM product_category_name_translation pc 
    JOIN products p 
		ON pc.product_category_name = p.product_category_name
	JOIN order_items oi 
		ON p.product_id = oi.product_id
    JOIN orders o 
		ON oi.order_id = o.order_id
GROUP BY product_category
ORDER BY total_revenue DESC, total_order DESC
LIMIT 10;

-- Notes:
-- - Categories are translated to English
-- - Results are ordered by revenue, then order volume
-- - Limited to top 10 categories


-- 1.3 Average Order Value (AOV) per customer

-- Purpose:
-- Calculate Average Order Value per customer to understand spending behavior at the customer level.

-- Metric definition:
-- AOV = total revenue / total number of orders per customer

WITH aov AS (
SELECT 	c.customer_id,
		SUM(oi.price) AS total_revenue,
        COUNT(DISTINCT(o.order_id)) AS total_order,
		ROUND(SUM(oi.price)/COUNT(DISTINCT(o.order_id)),2) AS average_order_value
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY c.customer_id
)

SELECT 	*,
        MAX(average_order_value) OVER() AS max_aov,
        MIN(average_order_value) OVER() AS min_aov
FROM aov
ORDER BY average_order_value DESC;

-- Notes:
-- - A Common Table Expression (CTE) is used to calculate total revenue,
--   total orders, and AOV per customer at an intermediate level.
-- - Window functions are used to expose global min and max AOV without additional aggregation queries.


-- 1.4 Top sellers by total revenue

-- Purpose:
-- Identify top-performing sellers based on total revenue generated and number of fulfilled orders.

SELECT 	s.seller_id,
		s.seller_state,
		COUNT(DISTINCT(o.order_id)) AS total_order,
		SUM(oi.price) AS total_revenue
FROM sellers s
JOIN order_items oi 
	ON s.seller_id = oi.seller_id
JOIN orders o 
	ON oi.order_id = o.order_id
GROUP BY s.seller_id, s.seller_state
ORDER BY total_revenue DESC, total_order DESC
LIMIT 10;

-- Notes:
-- - Revenue is calculated from order_items.price
-- - Grouped by seller and seller state
-- - Results limited to top 10 sellers


-- 1.5 Total revenue by customer state

-- Purpose:
-- Analyze geographic distribution of revenue based on customer location.

-- Metrics:
-- - Total orders
-- - Total revenue
-- - Average Order Value (AOV) per state

SELECT 	c.customer_state, 
		COUNT(DISTINCT(o.order_id)) AS total_order,
		SUM(oi.price) AS total_revenue,
        ROUND(SUM(oi.price)/COUNT(DISTINCT(o.order_id)),2) AS average_order_value
	FROM customers c
    JOIN orders o 
		ON c.customer_id = o.customer_id
	JOIN order_items oi 
		ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC, total_order DESC;

-- Notes:
-- Customer state is used to reflect demand-side geography


-- =========================
-- 2. Customer Behavior
-- =========================

-- 2.1 Number of unique customers per month

-- Purpose:
-- Track customer activity trends by counting unique customers per month.

SELECT 	MONTH(o.order_purchase_timestamp) AS month,
		MONTHNAME(o.order_purchase_timestamp) AS month_name,
		COUNT(DISTINCT(c.customer_id)) AS total_customer
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
GROUP BY month, month_name
ORDER BY month;

-- Notes:
-- - Based on order purchase date
-- - Counts distinct customers who placed at least one order in each month.


-- 2.2 Top customers by total spending

-- Purpose:
-- Identify highest-value customers based on total payment value.

SELECT 	c.customer_id,
		c.customer_state,
		SUM(op.payment_value) AS total_spending
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_payments op 
	ON o.order_id = op.order_id
GROUP BY c.customer_id, c.customer_state
ORDER BY total_spending DESC
LIMIT 10;

-- Notes:
-- - Uses order_payments.payment_value to reflect actual paid amount
-- - Grouped by customer and customer state
-- - Results limited to top 10 customers by total_spending


-- ===================================
-- 3. Delivery and Operational Metrics
-- ===================================

-- 3.1 Average delivery time

-- Purpose:
-- Measure delivery performance by calculating delivery duration from order purchase to customer delivery.

-- Metric definition:
-- Delivery time = order_delivered_customer_date - order_purchase_timestamp

-- a. Delivery time per order
WITH delivery_time_cte AS (
SELECT 	order_id,
		DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) 
			AS delivery_time
FROM orders)

SELECT 	order_id,
		delivery_time,
		MAX(delivery_time) OVER() AS max_delivery_time,
		MIN(delivery_time) OVER() AS min_delivery_time,
		ROUND(AVG(delivery_time) OVER()) AS average_delivery_time
FROM delivery_time_cte
ORDER BY delivery_time;

-- Notes:
-- - Window functions expose min, max, and average delivery time
-- - Supports benchmarking logistics performance


-- b. Orders with delivery time above average

-- Purpose:
-- Count how many orders exceed the overall average delivery time,
-- indicating delivery variability and potential delays.

WITH delivery_time_cte AS (
SELECT 	order_id,
		DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) 
			AS delivery_time
FROM orders)

SELECT COUNT(order_id) AS order_delivery_time_above_average
FROM delivery_time_cte
WHERE delivery_time > (SELECT AVG(delivery_time)
						AS average_delivery_time
                        FROM delivery_time_cte);


-- 3.2 Fastest and slowest sellers by delivery time

-- Purpose:
-- Evaluate seller-level fulfillment performance by comparing average delivery time per seller.

--  a. Slowest delivery time by sellers
WITH seller_delivery AS (
SELECT 	s.seller_id,
		s.seller_state,
        ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))) AS average_delivery_time
FROM sellers s 
JOIN order_items oi 
	ON s.seller_id = oi.seller_id
JOIN orders o 
	ON oi.order_id = o.order_id
GROUP BY s.seller_id, s.seller_state)

SELECT *
FROM seller_delivery
ORDER BY average_delivery_time DESC
LIMIT 10;
		
--  b. Fastest delivery time by sellers
WITH seller_delivery AS (
SELECT 	s.seller_id,
		s.seller_state,
        ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))) AS average_delivery_time
FROM sellers s 
JOIN order_items oi 
	ON s.seller_id = oi.seller_id
JOIN orders o 
	ON oi.order_id = o.order_id
GROUP BY s.seller_id, s.seller_state)

SELECT *
FROM seller_delivery
ORDER BY average_delivery_time
LIMIT 10;

-- Notes:
-- - Average delivery time is calculated per seller
-- - Results ranked to identify fastest and slowest sellers


-- 3.3 Late deliveries count

-- Purpose:
-- Quantify the number of orders delivered later than the estimated delivery date.

SELECT COUNT(*) AS total_late_deliveries
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;

-- Notes:
-- Late delivery occurs when: order_delivered_customer_date > order_estimated_delivery_date


-- ===================================
-- 4. Customer Feedback/ Satisfaction
-- ===================================

-- 4.1 Average review score per product category

-- Purpose:
-- Analyze customer satisfaction by calculating average review scores at the product category level.

WITH order_category AS (
SELECT DISTINCT oi.order_id,
				p.product_category_name
FROM order_items oi
JOIN products p 
	ON oi.product_id = p.product_id)

SELECT  pc.product_category_name_english AS product_category,
		ROUND(AVG(ov.review_score)) AS average_review_score
FROM order_category oc
JOIN product_category_name_translation pc
    ON oc.product_category_name = pc.product_category_name
JOIN order_reviews ov
    ON oc.order_id = ov.order_id
GROUP BY product_category
ORDER BY average_review_score DESC;

-- Notes:
-- - Order-level deduplication is applied to avoid review inflation
-- - Review scores range from 1 (lowest) to 5 (highest)


-- 4.2 Correlation between late delivery and review score

-- Purpose:
-- Examine how delivery delays relate to customer review scores.

-- Metrics:
-- - Number of delayed orders per review score
-- - Average delivery time for delayed orders

SELECT 	COUNT(o.order_id) AS total_delay_orders,
		ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)))
			AS average_delivery_time,
		ov.review_score
FROM orders o
JOIN order_reviews ov 
	ON o.order_id = ov.order_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY ov.review_score
ORDER BY ov.review_score;

-- Notes:
-- Focuses only on orders delivered later than estimated