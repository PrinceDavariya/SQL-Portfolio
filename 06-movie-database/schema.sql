-- ============================================================
-- 06 - MOVIE DATABASE — SCHEMA & SAMPLE DATA
-- Topics: Schema design, star schema thinking, CREATE TABLE, INSERT
-- Tool: DB Fiddle (https://www.db-fiddle.com/) — PostgreSQL 13
-- ============================================================

-- -----------------------------------------------
-- DROP tables (for clean re-runs)
-- -----------------------------------------------
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS directors;


-- -----------------------------------------------
-- CREATE tables
-- -----------------------------------------------

CREATE TABLE genres (
    genre_id    SERIAL PRIMARY KEY,
    genre_name  VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE directors (
    director_id   SERIAL PRIMARY KEY,
    director_name VARCHAR(100) NOT NULL
);

CREATE TABLE movies (
    movie_id      SERIAL PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    release_year  INTEGER NOT NULL,
    genre_id      INTEGER REFERENCES genres(genre_id),
    director_id   INTEGER REFERENCES directors(director_id)
);

CREATE TABLE ratings (
    rating_id   SERIAL PRIMARY KEY,
    movie_id    INTEGER REFERENCES movies(movie_id),
    user_name   VARCHAR(100) NOT NULL,
    score       NUMERIC(3,1) CHECK (score BETWEEN 0 AND 10),
    rated_at    DATE NOT NULL DEFAULT CURRENT_DATE
);


-- -----------------------------------------------
-- INSERT sample data — genres
-- -----------------------------------------------

INSERT INTO genres (genre_name) VALUES
    ('Action'),
    ('Drama'),
    ('Sci-Fi'),
    ('Comedy'),
    ('Thriller');


-- -----------------------------------------------
-- INSERT sample data — directors
-- -----------------------------------------------

INSERT INTO directors (director_name) VALUES
    ('Christopher Nolan'),
    ('Quentin Tarantino'),
    ('Denis Villeneuve'),
    ('Greta Gerwig'),
    ('Martin Scorsese'),
    ('Rian Johnson'),
    ('Jordan Peele');


-- -----------------------------------------------
-- INSERT sample data — movies
-- -----------------------------------------------

INSERT INTO movies (title, release_year, genre_id, director_id) VALUES
    ('Inception',            2010, 3, 1),  -- Sci-Fi, Nolan
    ('The Dark Knight',      2008, 1, 1),  -- Action, Nolan
    ('Interstellar',         2014, 3, 1),  -- Sci-Fi, Nolan
    ('Pulp Fiction',         1994, 2, 2),  -- Drama, Tarantino
    ('Inglourious Basterds', 2009, 2, 2),  -- Drama, Tarantino
    ('Django Unchained',     2012, 1, 2),  -- Action, Tarantino
    ('Arrival',              2016, 3, 3),  -- Sci-Fi, Villeneuve
    ('Dune',                 2021, 3, 3),  -- Sci-Fi, Villeneuve
    ('Blade Runner 2049',    2017, 3, 3),  -- Sci-Fi, Villeneuve
    ('Lady Bird',            2017, 2, 4),  -- Drama, Gerwig
    ('Barbie',               2023, 4, 4),  -- Comedy, Gerwig
    ('The Departed',         2006, 5, 5),  -- Thriller, Scorsese
    ('Goodfellas',           1990, 2, 5),  -- Drama, Scorsese
    ('Knives Out',           2019, 5, 6),  -- Thriller, Johnson
    ('Get Out',              2017, 5, 7);  -- Thriller, Peele


-- -----------------------------------------------
-- INSERT sample data — ratings
-- -----------------------------------------------

INSERT INTO ratings (movie_id, user_name, score, rated_at) VALUES
    (1,  'alice',   9.0, '2024-01-10'),
    (1,  'bob',     8.5, '2024-01-12'),
    (1,  'charlie', 9.5, '2024-01-15'),
    (2,  'alice',   9.5, '2024-01-11'),
    (2,  'diana',   9.0, '2024-01-13'),
    (2,  'eve',     8.0, '2024-01-14'),
    (3,  'bob',     8.0, '2024-02-01'),
    (3,  'charlie', 9.0, '2024-02-03'),
    (4,  'alice',   9.5, '2024-02-05'),
    (4,  'frank',   8.5, '2024-02-06'),
    (5,  'diana',   8.0, '2024-02-08'),
    (6,  'eve',     7.5, '2024-02-10'),
    (7,  'alice',   9.0, '2024-03-01'),
    (7,  'bob',     8.5, '2024-03-02'),
    (8,  'charlie', 8.0, '2024-03-05'),
    (8,  'diana',   8.5, '2024-03-06'),
    (9,  'frank',   9.0, '2024-03-08'),
    (10, 'alice',   8.5, '2024-03-10'),
    (10, 'eve',     7.5, '2024-03-11'),
    (11, 'bob',     7.0, '2024-04-01'),
    (11, 'charlie', 6.5, '2024-04-02'),
    (12, 'diana',   8.5, '2024-04-05'),
    (12, 'frank',   9.0, '2024-04-06'),
    (13, 'alice',   9.5, '2024-04-08'),
    (13, 'eve',     9.0, '2024-04-09'),
    (14, 'bob',     8.5, '2024-04-12'),
    (14, 'charlie', 9.0, '2024-04-13'),
    (15, 'diana',   9.0, '2024-04-15'),
    (15, 'frank',   8.5, '2024-04-16'),
    (1,  'diana',   8.0, '2024-04-18');
