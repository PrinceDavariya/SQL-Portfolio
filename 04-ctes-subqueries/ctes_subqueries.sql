-- ============================================================
-- 04 - CTEs & SUBQUERIES
-- Topics: Subqueries (inline, scalar, correlated), CTEs (WITH clause)
-- Practiced on: Select Star SQL (Chapters 2 & 3), DataLemur CTE Tutorial
-- ============================================================

-- -----------------------------------------------
-- SUBQUERIES — a query nested inside another query
-- -----------------------------------------------

-- Find all employees who earn above the company average salary
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Find the department with the highest total salary budget
SELECT dept_name
FROM departments
WHERE id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY SUM(salary) DESC
    LIMIT 1
);

-- Find employees in the same department as 'Alice'
SELECT name, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE name = 'Alice'
)
AND name != 'Alice';


-- -----------------------------------------------
-- IN / NOT IN with subqueries
-- -----------------------------------------------

-- Find employees who work in departments located in 'Paris'
SELECT name
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Paris'
);

-- Find customers who have NEVER placed an order
SELECT name
FROM customers
WHERE id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);


-- -----------------------------------------------
-- EXISTS — check if subquery returns any rows
-- -----------------------------------------------

-- Find departments that have at least one employee
SELECT dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
);


-- -----------------------------------------------
-- Inline subquery in FROM clause
-- -----------------------------------------------

-- Get average salary per department, then filter for above 60k
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name,
           ROUND(AVG(e.salary), 2) AS avg_salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.id
    GROUP BY d.dept_name
) AS dept_averages
WHERE avg_salary > 60000;


-- -----------------------------------------------
-- CTEs — WITH clause (cleaner than nested subqueries)
-- -----------------------------------------------

-- Same as above — but using a CTE (much more readable)
WITH dept_averages AS (
    SELECT d.dept_name,
           ROUND(AVG(e.salary), 2) AS avg_salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.id
    GROUP BY d.dept_name
)
SELECT dept_name, avg_salary
FROM dept_averages
WHERE avg_salary > 60000;


-- -----------------------------------------------
-- Multiple CTEs chained together
-- -----------------------------------------------

-- Step 1: Get total revenue per customer
-- Step 2: Rank them
-- Step 3: Show only the top 10
WITH customer_revenue AS (
    SELECT customer_id,
           SUM(total_price) AS total_spent
    FROM orders
    GROUP BY customer_id
),
customer_ranked AS (
    SELECT c.name,
           cr.total_spent,
           RANK() OVER (ORDER BY cr.total_spent DESC) AS spending_rank
    FROM customers c
    INNER JOIN customer_revenue cr ON c.id = cr.customer_id
)
SELECT name, total_spent, spending_rank
FROM customer_ranked
WHERE spending_rank <= 10;


-- -----------------------------------------------
-- Real-world CTE example — cohort-style analysis
-- -----------------------------------------------

-- Find customers who placed their first order in 2024
-- and how much they've spent total since then
WITH first_orders AS (
    SELECT customer_id,
           MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
),
new_customers_2024 AS (
    SELECT customer_id
    FROM first_orders
    WHERE EXTRACT(YEAR FROM first_order_date) = 2024
)
SELECT c.name,
       SUM(o.total_price) AS lifetime_value
FROM customers c
INNER JOIN new_customers_2024 nc ON c.id = nc.customer_id
INNER JOIN orders o              ON c.id = o.customer_id
GROUP BY c.name
ORDER BY lifetime_value DESC;
