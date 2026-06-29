-- ============================================================
-- 03 - AGGREGATIONS & GROUP BY
-- Topics: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- Practiced on: SQLBolt (Lessons 12-13), pgexercises.com (Aggregates section),
--               Select Star SQL (Chapter 1)
-- ============================================================

-- Tables used:
--   orders     (id, customer_id, product_id, quantity, total_price, order_date)
--   customers  (id, name, country)
--   products   (id, product_name, category, unit_price)


-- -----------------------------------------------
-- Basic aggregate functions
-- -----------------------------------------------

-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Count only orders with a price above 100
SELECT COUNT(*) AS large_orders
FROM orders
WHERE total_price > 100;

-- Total revenue
SELECT SUM(total_price) AS total_revenue
FROM orders;

-- Average order value
SELECT ROUND(AVG(total_price), 2) AS avg_order_value
FROM orders;

-- Most expensive and cheapest product
SELECT MAX(unit_price) AS most_expensive,
       MIN(unit_price) AS cheapest
FROM products;


-- -----------------------------------------------
-- GROUP BY — aggregate per group
-- -----------------------------------------------

-- Total orders per country
SELECT c.country,
       COUNT(o.id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.country
ORDER BY total_orders DESC;

-- Total revenue per product category
SELECT p.category,
       SUM(o.total_price) AS revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.id
GROUP BY p.category
ORDER BY revenue DESC;

-- Average order value per customer
SELECT c.name,
       ROUND(AVG(o.total_price), 2) AS avg_order_value,
       COUNT(o.id)                  AS total_orders
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
ORDER BY avg_order_value DESC;

-- Number of orders per month
SELECT DATE_TRUNC('month', order_date) AS month,
       COUNT(*)                         AS orders_that_month
FROM orders
GROUP BY month
ORDER BY month;


-- -----------------------------------------------
-- HAVING — filter groups after aggregation
-- (WHERE filters rows BEFORE grouping, HAVING filters AFTER)
-- -----------------------------------------------

-- Countries with more than 50 orders
SELECT c.country,
       COUNT(o.id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.country
HAVING COUNT(o.id) > 50
ORDER BY total_orders DESC;

-- Product categories with average price above 200
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 200;

-- Customers who have spent more than 1000 in total
SELECT c.name,
       SUM(o.total_price) AS total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING SUM(o.total_price) > 1000
ORDER BY total_spent DESC;


-- -----------------------------------------------
-- Combining WHERE + GROUP BY + HAVING + ORDER BY
-- (this is the correct SQL clause order)
-- -----------------------------------------------

-- Top 5 countries by revenue, only counting orders above 50
SELECT c.country,
       SUM(o.total_price) AS revenue
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.total_price > 50          -- filter rows first
GROUP BY c.country                -- then group
HAVING SUM(o.total_price) > 500   -- then filter groups
ORDER BY revenue DESC             -- then sort
LIMIT 5;                          -- then limit


-- -----------------------------------------------
-- Practical examples (pgexercises-style)
-- -----------------------------------------------

-- Count the number of recommendations each member has made
SELECT recommendedby,
       COUNT(*) AS num_recommendations
FROM members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY num_recommendations DESC;

-- List facilities with total revenue greater than 1000
SELECT f.name,
       SUM(b.slots * (
           CASE WHEN b.memid = 0 THEN f.guestcost
                ELSE f.membercost END
       )) AS revenue
FROM bookings b
INNER JOIN facilities f ON b.facid = f.facid
GROUP BY f.name
HAVING SUM(b.slots * (
    CASE WHEN b.memid = 0 THEN f.guestcost
         ELSE f.membercost END
)) > 1000
ORDER BY revenue DESC;
