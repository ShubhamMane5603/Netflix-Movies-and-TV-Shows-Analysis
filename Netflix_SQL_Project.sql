create database Netflix;
select * from netflix_1;
select * from netflix_2;

-- What is the top 10 movies according to IMDB score?
SELECT title, type, imdb_score
FROM netflix_1
WHERE imdb_score >= 8.0 AND type = 'MOVIE'
ORDER BY imdb_score DESC
LIMIT 10;

-- What is the top 10 shows according to IMDB score? 
SELECT title, type, imdb_score
FROM netflix_1
WHERE imdb_score >= 8.0
AND type = 'SHOW'
ORDER BY imdb_score DESC
LIMIT 10;

-- What is the bottom 10 movies according to IMDB score? 
SELECT title, type, imdb_score
FROM netflix_1
WHERE type = 'MOVIE'
ORDER BY imdb_score ASC
LIMIT 10;

-- What is the bottom 10 shows according to IMDB score? 
SELECT title, type, imdb_score
FROM netflix_1
WHERE type = 'SHOW'
ORDER BY imdb_score ASC
LIMIT 10;

-- what is count of year wise produced movie
select release_year,count(release_year)  as years from netflix_1
group by release_year
order by years desc;


-- what is the percentage of show and movie
SELECT type,COUNT(*) AS count,COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_1) AS percentage
FROM netflix_1
GROUP BY type;

-- what is the percentage of each age certification
select age_certification,count(age_certification),count(age_certification)*100 / (select count(age_certification) from netflix_1) as per
from netflix_1
group by age_certification
order by per desc;

--  what is the percentage of each genres
select genres,count(genres)*100 / (select count(*) from netflix_1) as per
from netflix_1
group by genres
order by per desc;


-- What is the average IMDB and TMDB scores for shows and movies? 
SELECT DISTINCT type, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) as avg_tmdb_score
FROM netflix_1
GROUP BY type; 


-- What is the average IMDB and TMDB scores for each production country?
SELECT DISTINCT production_countries, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM netflix_1
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;

-- What is the average IMDB and TMDB scores for each age certification for shows and movies?
SELECT DISTINCT age_certification, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM netflix_1
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;

-- What is the 5 most common age certifications for movies?
SELECT age_certification, 
COUNT(*) AS certification_count
FROM netflix_1
WHERE type = 'Movie' 
AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;

-- Who is the top 20 actors that appeared the most in movies/shows? 
SELECT DISTINCT name as actor, 
COUNT(*) AS number_of_appearences 
FROM netflix_2
WHERE role = 'actor'
GROUP BY name
ORDER BY number_of_appearences DESC
LIMIT 20;

-- Who is the top 20 directors that directed the most movies/shows? 
SELECT DISTINCT name as director, 
COUNT(*) AS number_of_appearences 
FROM netflix_2
WHERE role = 'director'
GROUP BY name
ORDER BY number_of_appearences DESC
LIMIT 20;

-- Calculating the average runtime of movies and TV shows separately
SELECT 
'Movies' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM netflix_1
WHERE type = 'Movie'
UNION ALL
SELECT 
'Show' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM netflix_1
WHERE type = 'Show';


-- Finding the titles and  directors of movies released on or after 2010
SELECT DISTINCT t.title, c.name AS director, 
release_year
FROM netflix_1 AS t
JOIN netflix_2 AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
AND t.release_year >= 2010 
AND c.role = 'director'
ORDER BY release_year DESC;

-- Which shows on Netflix have the most seasons?
SELECT title, 
SUM(seasons) AS total_seasons
FROM netflix_1 
WHERE type = 'Show'
GROUP BY title
ORDER BY total_seasons DESC
LIMIT 10;

-- Which genres is the most movies? 
SELECT genres, 
COUNT(*) AS title_count
FROM netflix_1 
WHERE type = 'Movie'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- Which genres is the most shows? 
SELECT genres, 
COUNT(*) AS title_count
FROM netflix_1 
WHERE type = 'Show'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- Titles and Directors of movies with high IMDB scores (>7.5) and high TMDB popularity scores (>80) 
SELECT a.title,b.name AS director
FROM netflix_1 AS a
inner JOIN netflix_2 AS b 
ON a.id = b.id
WHERE a.type = 'Movie' AND a.imdb_score > 7.5 AND a.tmdb_popularity > 80 AND b.role_played = 'director';


-- Actors who have starred in the most highly rated movies or shows
SELECT a.name AS actor, COUNT(*) AS num_highly_rated_titles
FROM netflix_2 AS a
JOIN netflix_1 as  b 
ON a.id = b.id
WHERE a.role_played = 'actor' AND (b.type = 'Movie' OR b.type = 'Show') AND b.imdb_score > 8.0 AND b.tmdb_score > 8.0
GROUP BY a.name
ORDER BY num_highly_rated_titles DESC;

-- Which actors/actresses played the same character in multiple movies or TV shows? 
SELECT a.name AS actor_or_actress, a.character_play, COUNT(DISTINCT b.title) AS num_titles
FROM netflix_2 AS a
JOIN netflix_1 AS b 
ON a.id = b.id
WHERE a.role_played = 'actor' OR a.role_played = 'actress'
GROUP BY a.name, a.character_play
HAVING COUNT(DISTINCT b.title) > 1;

-- What were the top 3 most common genres?
SELECT t.genres, 
COUNT(*) AS genre_count
FROM netflix_1 AS t
WHERE t.type = 'Movie'
GROUP BY t.genres
ORDER BY genre_count DESC
LIMIT 3;

-- Average IMDB score for leading actors/actresses in movies or shows 
SELECT a.name AS actor_or_actress, ROUND(AVG(b.imdb_score),2) AS average_imdb_score
FROM netflix_2 AS a
JOIN netflix_1 AS b 
ON a.id = b.id
WHERE a.role_played = 'actor' OR a.role_played = 'actress' AND a.character_play = 'leading role'
GROUP BY a.name
ORDER BY average_imdb_score DESC;



                                                          
													


