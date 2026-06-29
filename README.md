# 🗄️ SQL Portfolio — Week 1 Data Engineering Sprint

> **Prince Davariya** · MSc Data Engineering & Cloud Computing · aivancity, France  
> 📍 [GitHub](https://github.com/PrinceDavariya) · [LinkedIn](https://linkedin.com/in/prince-davariya-406148247)

---

## 📌 About This Repository

This repository documents my **Week 1 SQL work** as part of a focused 30-day Data Engineering learning sprint.

It covers everything from foundational querying to analytical SQL patterns used in real data engineering roles — including joins, aggregations, CTEs, window functions, and a full data modeling exercise.

All queries were written and tested on live databases using interactive platforms (SQLBolt, pgexercises.com, DataLemur, Select Star SQL).

---

## 📁 Repository Structure

```
sql-portfolio/
│
├── README.md
│
├── 01-foundations/
│   └── basics.sql              # SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
│
├── 02-joins/
│   └── joins.sql               # INNER, LEFT, RIGHT, FULL OUTER, self-joins
│
├── 03-aggregations/
│   └── aggregations.sql        # COUNT, SUM, AVG, GROUP BY, HAVING
│
├── 04-ctes-subqueries/
│   └── ctes_subqueries.sql     # WITH clause, nested queries, CTEs
│
├── 05-window-functions/
│   └── window_functions.sql    # RANK, ROW_NUMBER, LAG, LEAD, PARTITION BY
│
├── 06-movie-database/
│   ├── schema.sql              # CREATE TABLE statements + sample data
│   └── analysis_queries.sql    # 5 analytical queries on the movie dataset
│
└── 07-danny-ma-case-study-1/
    └── solutions.sql           # My solutions to Danny Ma's Diner challenge
```

---

## 🧠 SQL Concepts Covered

| Concept | File | Difficulty |
|---------|------|------------|
| SELECT, WHERE, ORDER BY, LIMIT | `01-foundations/basics.sql` | ⭐ Basic |
| INNER, LEFT, RIGHT, FULL OUTER JOIN | `02-joins/joins.sql` | ⭐ Basic |
| COUNT, SUM, AVG, GROUP BY, HAVING | `03-aggregations/aggregations.sql` | ⭐ Basic |
| Subqueries & CTEs (WITH clause) | `04-ctes-subqueries/ctes_subqueries.sql` | ⭐⭐ Medium |
| RANK, ROW_NUMBER, LAG, LEAD, PARTITION BY | `05-window-functions/window_functions.sql` | ⭐⭐ Medium |
| Schema design + data modeling | `06-movie-database/schema.sql` | ⭐⭐ Medium |
| Real business SQL problems | `07-danny-ma-case-study-1/solutions.sql` | ⭐⭐ Medium |

---

## 🎬 Movie Database — Schema Design

A custom database built to practice relational modeling and analytical SQL.

```
┌─────────────────┐         ┌──────────────────┐
│     movies      │         │     genres       │
├─────────────────┤         ├──────────────────┤
│ movie_id (PK)   │────────▶│ genre_id (PK)    │
│ title           │         │ genre_name       │
│ release_year    │         └──────────────────┘
│ genre_id (FK)   │
└────────┬────────┘
         │
         │
┌────────▼────────┐         ┌──────────────────┐
│    ratings      │         │    directors     │
├─────────────────┤         ├──────────────────┤
│ rating_id (PK)  │         │ director_id (PK) │
│ movie_id (FK)   │         │ name             │
│ user_name       │         │ movie_id (FK)    │
│ score           │         └──────────────────┘
│ rated_at        │
└─────────────────┘
```

### Analytical Questions Answered

1. Which genre has the highest average rating?
2. Top 5 highest-rated movies with their genre name
3. Rating rank of each movie **within its genre** using `RANK() OVER (PARTITION BY ...)`
4. Number of movies released per year
5. Users who have rated more than 3 movies
6. ⭐ Bonus — Each director's best-rated movie using a CTE

---

## 🍜 Danny Ma — 8 Week SQL Challenge: Case Study 1 (Danny's Diner)

[Case Study Link](https://8weeksqlchallenge.com/case-study-1/)

Danny's Diner is a restaurant that wants to understand customer visiting patterns, spending habits, and favourite menu items.

### Dataset Tables
- `sales` — customer_id, order_date, product_id
- `menu` — product_id, product_name, price
- `members` — customer_id, join_date

### Questions Solved

| # | Question |
|---|----------|
| 1 | What is the total amount each customer spent? |
| 2 | How many days has each customer visited the restaurant? |
| 3 | What was the first item from the menu purchased by each customer? |
| 4 | What is the most purchased item on the menu? |
| 5 | Which item was the most popular for each customer? |
| 6 | Which item was purchased first by the customer after they became a member? |
| 7 | Which item was purchased just before the customer became a member? |
| 8 | What is the total items and amount spent for each member before they became a member? |
| 9 | If each $1 spent equates to 10 points, how many points would each customer have? |
| 10 | In the first week after a customer joins the program, they earn 2x points — how many points does each customer have? |

---

## 🛠️ Tools & Platforms Used

| Platform | Purpose |
|----------|---------|
| [SQLBolt](https://sqlbolt.com/) | Interactive SQL fundamentals (Lessons 1–13) |
| [pgexercises.com](https://pgexercises.com/) | Real PostgreSQL practice (Basic, Joins, Aggregates) |
| [Select Star SQL](https://selectstarsql.com/) | CTEs and subqueries with real data |
| [DataLemur](https://datalemur.com/sql-tutorial/sql-window-functions) | Window functions + interview-level practice |
| [Danny Ma 8-Week Challenge](https://8weeksqlchallenge.com/) | Real business SQL case studies |
| [DB Fiddle](https://www.db-fiddle.com/) | Query testing and schema validation |
| [dbdiagram.io](https://dbdiagram.io) | Schema design and ERD diagrams |

---

## 📈 What's Next

This is **Week 1** of a 30-day Data Engineering sprint. Coming up:

- **Week 2** — Python ETL pipelines (pandas, APIs, Parquet, data validation)
- **Week 3** — Apache Airflow orchestration + PySpark basics
- **Week 4** — Cloud (AWS/GCP), end-to-end capstone project, interview prep

Follow along on [LinkedIn](https://linkedin.com/in/prince-davariya-406148247) for weekly updates.

---

## 👤 About Me

I'm an MSc Data Engineering & Cloud Computing student at **aivancity** (France), transitioning from a frontend development background into data engineering and AI.

Currently seeking an **internship or alternance** in Data Engineering in France (Paris region preferred).

- 🌐 [GitHub](https://github.com/PrinceDavariya)
- 💼 [LinkedIn](https://linkedin.com/in/prince-davariya-406148247)
