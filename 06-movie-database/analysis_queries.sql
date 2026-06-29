-- ============================================================
-- 06 - MOVIE DATABASE — ANALYTICAL QUERIES
-- Run schema.sql first to create tables and insert data
-- ============================================================


-- -----------------------------------------------
-- Query 1: Which genre has the highest average rating?
-- -----------------------------------------------

SELECT g.genre_name,
       ROUND(AVG(r.score), 2) AS avg_rating,
       COUNT(r.rating_id)     AS total_ratings
FROM genres g
INNER JOIN movies m  ON g.genre_id = m.genre_id
INNER JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY g.genre_name
ORDER BY avg_rating DESC;

-- Expected insight: Sci-Fi and Drama tend to rate highest


-- -----------------------------------------------
-- Query 2: Top 5 highest-rated movies with their genre
-- -----------------------------------------------

SELECT m.title,
       g.genre_name,
       ROUND(AVG(r.score), 2) AS avg_rating,
       COUNT(r.rating_id)     AS num_ratings
FROM movies m
INNER JOIN genres g  ON m.genre_id = g.genre_id
INNER JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.title, g.genre_name
ORDER BY avg_rating DESC
LIMIT 5;


-- -----------------------------------------------
-- Query 3: Rating rank of each movie WITHIN its genre
--          using RANK() window function
-- -----------------------------------------------

WITH movie_avg_ratings AS (
    SELECT m.movie_id,
           m.title,
           g.genre_name,
           ROUND(AVG(r.score), 2) AS avg_rating
    FROM movies m
    INNER JOIN genres g  ON m.genre_id = g.genre_id
    INNER JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title, g.genre_name
)
SELECT title,
       genre_name,
       avg_rating,
       RANK() OVER (
           PARTITION BY genre_name
           ORDER BY avg_rating DESC
       ) AS rank_within_genre
FROM movie_avg_ratings
ORDER BY genre_name, rank_within_genre;

-- This shows RANK() resetting back to 1 for each new genre


-- -----------------------------------------------
-- Query 4: How many movies were released each year?
-- -----------------------------------------------

SELECT release_year,
       COUNT(movie_id) AS movies_released
FROM movies
GROUP BY release_year
ORDER BY release_year DESC;


-- -----------------------------------------------
-- Query 5: Which users have rated more than 2 movies?
-- -----------------------------------------------

SELECT user_name,
       COUNT(DISTINCT movie_id) AS movies_rated,
       ROUND(AVG(score), 2)     AS their_avg_score
FROM ratings
GROUP BY user_name
HAVING COUNT(DISTINCT movie_id) > 2
ORDER BY movies_rated DESC;


-- -----------------------------------------------
-- Bonus Query: Each director's best-rated movie (using CTE)
-- -----------------------------------------------

WITH director_movie_ratings AS (
    SELECT d.director_name,
           m.title,
           ROUND(AVG(r.score), 2) AS avg_rating,
           RANK() OVER (
               PARTITION BY d.director_id
               ORDER BY AVG(r.score) DESC
           ) AS rnk
    FROM directors d
    INNER JOIN movies m  ON d.director_id = m.director_id
    INNER JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY d.director_id, d.director_name, m.movie_id, m.title
)
SELECT director_name,
       title        AS best_rated_movie,
       avg_rating
FROM director_movie_ratings
WHERE rnk = 1
ORDER BY avg_rating DESC;
