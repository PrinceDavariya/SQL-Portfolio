-- ============================================================
-- 05 - WINDOW FUNCTIONS
-- Topics: ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, PARTITION BY,
--         running totals, moving averages
-- Practiced on: DataLemur Window Functions Tutorial + Interview Questions
-- ============================================================

-- KEY CONCEPT:
-- Window functions perform a calculation across a set of rows
-- RELATED to the current row — without collapsing them like GROUP BY does.
-- Syntax: FUNCTION() OVER (PARTITION BY col ORDER BY col)


-- -----------------------------------------------
-- ROW_NUMBER — unique sequential number per row
-- -----------------------------------------------

-- Number each employee within their department by salary (highest = 1)
SELECT name,
       department_id,
       salary,
       ROW_NUMBER() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS row_num
FROM employees;


-- -----------------------------------------------
-- RANK — same rank for ties, skips next number
-- -----------------------------------------------

-- Rank employees by salary within each department
-- If two people tie at rank 2, next rank is 4 (not 3)
SELECT name,
       department_id,
       salary,
       RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS salary_rank
FROM employees;


-- -----------------------------------------------
-- DENSE_RANK — same rank for ties, no gaps
-- -----------------------------------------------

-- Dense rank — if two people tie at rank 2, next rank is 3
SELECT name,
       department_id,
       salary,
       DENSE_RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS dense_rank
FROM employees;


-- -----------------------------------------------
-- Comparing all three ranking functions side by side
-- -----------------------------------------------

SELECT name,
       salary,
       ROW_NUMBER()  OVER (ORDER BY salary DESC) AS row_number,
       RANK()        OVER (ORDER BY salary DESC) AS rank,
       DENSE_RANK()  OVER (ORDER BY salary DESC) AS dense_rank
FROM employees;

-- Output when salaries are: 90k, 90k, 80k, 70k
-- row_number: 1, 2, 3, 4
-- rank:       1, 1, 3, 4   (skips 2)
-- dense_rank: 1, 1, 2, 3   (no gaps)


-- -----------------------------------------------
-- Get top N per group (common interview pattern)
-- -----------------------------------------------

-- Top 3 highest paid employees per department
WITH ranked AS (
    SELECT name,
           department_id,
           salary,
           DENSE_RANK() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT name, department_id, salary
FROM ranked
WHERE rnk <= 3;


-- -----------------------------------------------
-- LAG — access value from previous row
-- -----------------------------------------------

-- Compare each month's revenue to the previous month
SELECT month,
       revenue,
       LAG(revenue, 1) OVER (ORDER BY month) AS prev_month_revenue,
       revenue - LAG(revenue, 1) OVER (ORDER BY month) AS revenue_change
FROM monthly_revenue;

-- Was the employee's salary higher than the person hired before them?
SELECT name,
       hire_date,
       salary,
       LAG(salary) OVER (ORDER BY hire_date) AS prev_hire_salary
FROM employees
ORDER BY hire_date;


-- -----------------------------------------------
-- LEAD — access value from next row
-- -----------------------------------------------

-- Show each employee's salary and the next highest salary above them
SELECT name,
       salary,
       LEAD(salary) OVER (ORDER BY salary DESC) AS next_lower_salary
FROM employees;


-- -----------------------------------------------
-- Running totals with SUM() OVER
-- -----------------------------------------------

-- Cumulative revenue by order date
SELECT order_date,
       daily_revenue,
       SUM(daily_revenue) OVER (
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_revenue
FROM daily_sales;


-- -----------------------------------------------
-- Moving average with AVG() OVER
-- -----------------------------------------------

-- 7-day moving average of daily sales
SELECT order_date,
       daily_revenue,
       ROUND(AVG(daily_revenue) OVER (
           ORDER BY order_date
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_7d
FROM daily_sales;


-- -----------------------------------------------
-- NTILE — divide rows into N equal buckets
-- -----------------------------------------------

-- Divide employees into 4 salary quartiles
SELECT name,
       salary,
       NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;


-- -----------------------------------------------
-- DataLemur-style interview question
-- -----------------------------------------------

-- Find the top earner in each department (handle ties)
WITH dept_top AS (
    SELECT name,
           department_id,
           salary,
           RANK() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT name, department_id, salary
FROM dept_top
WHERE rnk = 1
ORDER BY department_id;
