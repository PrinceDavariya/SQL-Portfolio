-- ============================================================
-- 07 - DANNY MA: 8-WEEK SQL CHALLENGE — CASE STUDY 1
-- Danny's Diner | https://8weeksqlchallenge.com/case-study-1/
-- ============================================================

-- SCHEMA
-- -----------------------------------------------
-- sales    (customer_id VARCHAR, order_date DATE, product_id INT)
-- menu     (product_id INT, product_name VARCHAR, price INT)
-- members  (customer_id VARCHAR, join_date DATE)


-- -----------------------------------------------
-- Q1: What is the total amount each customer spent?
-- -----------------------------------------------

SELECT s.customer_id,
       SUM(m.price) AS total_spent
FROM sales s
INNER JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spent DESC;

-- Result: Customer A spent the most, then B, then C


-- -----------------------------------------------
-- Q2: How many days has each customer visited the restaurant?
-- -----------------------------------------------

SELECT customer_id,
       COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id
ORDER BY visit_days DESC;

-- Using DISTINCT because one visit can have multiple orders


-- -----------------------------------------------
-- Q3: What was the first item purchased by each customer?
-- -----------------------------------------------

WITH first_order AS (
    SELECT customer_id,
           product_id,
           order_date,
           RANK() OVER (
               PARTITION BY customer_id
               ORDER BY order_date ASC
           ) AS rnk
    FROM sales
)
SELECT fo.customer_id,
       m.product_name AS first_item
FROM first_order fo
INNER JOIN menu m ON fo.product_id = m.product_id
WHERE fo.rnk = 1;

-- RANK instead of ROW_NUMBER to handle ties (same date, multiple items)


-- -----------------------------------------------
-- Q4: What is the most purchased item and how many times?
-- -----------------------------------------------

SELECT m.product_name,
       COUNT(s.product_id) AS times_purchased
FROM sales s
INNER JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY times_purchased DESC
LIMIT 1;

-- Result: Ramen is the most purchased item


-- -----------------------------------------------
-- Q5: Which item was the most popular for each customer?
-- -----------------------------------------------

WITH customer_item_counts AS (
    SELECT customer_id,
           product_id,
           COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id, product_id
),
ranked AS (
    SELECT customer_id,
           product_id,
           purchase_count,
           RANK() OVER (
               PARTITION BY customer_id
               ORDER BY purchase_count DESC
           ) AS rnk
    FROM customer_item_counts
)
SELECT r.customer_id,
       m.product_name AS favourite_item,
       r.purchase_count
FROM ranked r
INNER JOIN menu m ON r.product_id = m.product_id
WHERE r.rnk = 1
ORDER BY r.customer_id;


-- -----------------------------------------------
-- Q6: Which item was purchased FIRST after a customer became a member?
-- -----------------------------------------------

WITH member_purchases AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           RANK() OVER (
               PARTITION BY s.customer_id
               ORDER BY s.order_date ASC
           ) AS rnk
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date >= mb.join_date  -- only orders ON or AFTER joining
)
SELECT mp.customer_id,
       m.product_name AS first_member_purchase
FROM member_purchases mp
INNER JOIN menu m ON mp.product_id = m.product_id
WHERE mp.rnk = 1;


-- -----------------------------------------------
-- Q7: Which item was purchased JUST BEFORE a customer became a member?
-- -----------------------------------------------

WITH pre_member_purchases AS (
    SELECT s.customer_id,
           s.product_id,
           s.order_date,
           RANK() OVER (
               PARTITION BY s.customer_id
               ORDER BY s.order_date DESC  -- most recent BEFORE joining
           ) AS rnk
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date < mb.join_date  -- only orders BEFORE joining
)
SELECT pmp.customer_id,
       m.product_name AS last_pre_member_purchase
FROM pre_member_purchases pmp
INNER JOIN menu m ON pmp.product_id = m.product_id
WHERE pmp.rnk = 1;


-- -----------------------------------------------
-- Q8: Total items and amount spent BEFORE becoming a member
-- -----------------------------------------------

SELECT s.customer_id,
       COUNT(s.product_id)  AS total_items,
       SUM(m.price)         AS total_spent
FROM sales s
INNER JOIN menu m    ON s.product_id = m.product_id
INNER JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;


-- -----------------------------------------------
-- Q9: Points calculation — $1 = 10 points
--     Sushi gets 2x multiplier
-- -----------------------------------------------

SELECT s.customer_id,
       SUM(
           CASE
               WHEN m.product_name = 'sushi' THEN m.price * 20  -- 2x multiplier
               ELSE m.price * 10
           END
       ) AS total_points
FROM sales s
INNER JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_points DESC;


-- -----------------------------------------------
-- Q10: Double points in first week of membership
--      (first 7 days after joining, all items = 2x)
--      + sushi always 2x
--      — only for January 2021
-- -----------------------------------------------

SELECT s.customer_id,
       SUM(
           CASE
               -- First week of membership: all items get 2x
               WHEN s.order_date BETWEEN mb.join_date AND mb.join_date + INTERVAL '6 days'
                   THEN m.price * 20
               -- Outside first week but sushi still 2x
               WHEN m.product_name = 'sushi'
                   THEN m.price * 20
               -- Everything else: 1x
               ELSE m.price * 10
           END
       ) AS total_points
FROM sales s
INNER JOIN menu m     ON s.product_id = m.product_id
INNER JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date <= '2021-01-31'  -- January only
GROUP BY s.customer_id
ORDER BY total_points DESC;


-- -----------------------------------------------
-- Bonus: Create a summary table with membership status per order
-- -----------------------------------------------

SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
       CASE
           WHEN s.order_date >= mb.join_date THEN 'Y'
           ELSE 'N'
       END AS member_at_time_of_order
FROM sales s
INNER JOIN menu m          ON s.product_id = m.product_id
LEFT JOIN  members mb      ON s.customer_id = mb.customer_id
ORDER BY s.customer_id, s.order_date;
