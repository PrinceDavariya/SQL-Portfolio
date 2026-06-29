-- ============================================================
-- 01 - SQL FOUNDATIONS
-- Topics: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, NULL handling
-- Practiced on: SQLBolt (Lessons 1-8)
-- ============================================================

-- Using a sample employees dataset for demonstration
-- Table: employees (id, name, department, salary, city, hire_date)

-- -----------------------------------------------
-- SELECT basics
-- -----------------------------------------------

-- Get all columns
SELECT * FROM employees;

-- Get specific columns only
SELECT name, department, salary
FROM employees;

-- Rename columns with aliases
SELECT name AS employee_name,
       salary AS monthly_salary
FROM employees;


-- -----------------------------------------------
-- WHERE — filtering rows
-- -----------------------------------------------

-- Employees in the Engineering department
SELECT name, salary
FROM employees
WHERE department = 'Engineering';

-- Salary above 50,000
SELECT name, department, salary
FROM employees
WHERE salary > 50000;

-- Multiple conditions with AND
SELECT name, department, salary
FROM employees
WHERE department = 'Engineering'
  AND salary > 60000;

-- Multiple conditions with OR
SELECT name, department
FROM employees
WHERE department = 'Engineering'
   OR department = 'Data';

-- NOT operator
SELECT name, department
FROM employees
WHERE department != 'HR';


-- -----------------------------------------------
-- LIKE — pattern matching
-- -----------------------------------------------

-- Names starting with 'A'
SELECT name FROM employees
WHERE name LIKE 'A%';

-- Names ending with 'son'
SELECT name FROM employees
WHERE name LIKE '%son';

-- Names containing 'an'
SELECT name FROM employees
WHERE name LIKE '%an%';


-- -----------------------------------------------
-- NULL handling
-- -----------------------------------------------

-- Find employees with no city listed
SELECT name, city
FROM employees
WHERE city IS NULL;

-- Find employees who DO have a city listed
SELECT name, city
FROM employees
WHERE city IS NOT NULL;


-- -----------------------------------------------
-- ORDER BY — sorting
-- -----------------------------------------------

-- Sort by salary highest to lowest
SELECT name, salary
FROM employees
ORDER BY salary DESC;

-- Sort by department A-Z, then salary high to low
SELECT name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;


-- -----------------------------------------------
-- LIMIT — restricting rows returned
-- -----------------------------------------------

-- Top 5 highest paid employees
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;


-- -----------------------------------------------
-- DISTINCT — removing duplicates
-- -----------------------------------------------

-- All unique departments
SELECT DISTINCT department
FROM employees;

-- All unique cities where employees are based
SELECT DISTINCT city
FROM employees
WHERE city IS NOT NULL;


-- -----------------------------------------------
-- Combining everything
-- -----------------------------------------------

-- Top 3 highest-paid Engineering employees from Paris
SELECT name, salary, city
FROM employees
WHERE department = 'Engineering'
  AND city = 'Paris'
ORDER BY salary DESC
LIMIT 3;
