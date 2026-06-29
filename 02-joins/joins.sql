-- ============================================================
-- 02 - SQL JOINS
-- Topics: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, Self Join
-- Practiced on: SQLBolt (Lessons 9-11), pgexercises.com (Joins section)
-- ============================================================

-- Tables used:
--   employees  (id, name, department_id, manager_id, salary)
--   departments (id, dept_name, location)
--   projects    (id, project_name, department_id)


-- -----------------------------------------------
-- INNER JOIN — only matching rows from both tables
-- -----------------------------------------------

-- Get each employee with their department name
-- Employees without a department are excluded
SELECT e.name,
       d.dept_name,
       e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;


-- -----------------------------------------------
-- LEFT JOIN — all rows from left table, matching from right
-- -----------------------------------------------

-- Get all employees, even those with no department assigned
SELECT e.name,
       d.dept_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

-- Find employees who have NO department (NULL after left join)
SELECT e.name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;


-- -----------------------------------------------
-- RIGHT JOIN — all rows from right table, matching from left
-- -----------------------------------------------

-- Get all departments, even ones with no employees
SELECT e.name,
       d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;


-- -----------------------------------------------
-- FULL OUTER JOIN — all rows from both tables
-- -----------------------------------------------

-- Get all employees AND all departments, matching where possible
SELECT e.name,
       d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;


-- -----------------------------------------------
-- Multiple JOINs — chaining more than two tables
-- -----------------------------------------------

-- Get employee name, department name, and the project their department works on
SELECT e.name        AS employee,
       d.dept_name   AS department,
       p.project_name AS project
FROM employees e
INNER JOIN departments d  ON e.department_id = d.id
INNER JOIN projects p     ON d.id = p.department_id;


-- -----------------------------------------------
-- SELF JOIN — joining a table to itself
-- -----------------------------------------------

-- Get each employee and their manager's name
-- (manager_id references id in the same employees table)
SELECT e.name        AS employee,
       m.name        AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;


-- -----------------------------------------------
-- Practical examples (pgexercises-style)
-- -----------------------------------------------

-- List all members who have made a booking, with facility name
-- Tables: members(memid, firstname, surname), bookings(memid, facid), facilities(facid, name)
SELECT DISTINCT m.firstname || ' ' || m.surname AS member_name,
       f.name AS facility
FROM members m
INNER JOIN bookings b  ON m.memid = b.memid
INNER JOIN facilities f ON b.facid = f.facid
ORDER BY member_name;

-- Find members who have never made a booking
SELECT m.firstname, m.surname
FROM members m
LEFT JOIN bookings b ON m.memid = b.memid
WHERE b.memid IS NULL;

-- List all facilities with at least one booking, showing total slots booked
SELECT f.name,
       SUM(b.slots) AS total_slots_booked
FROM facilities f
INNER JOIN bookings b ON f.facid = b.facid
GROUP BY f.name
ORDER BY total_slots_booked DESC;
