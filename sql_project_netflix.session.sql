
-- netflix Project

CREATE TABLE netflix (
             show_id VARCHAR(6),
             type VARCHAR(10),
             title VARCHAR(150) ,
             director VARCHAR(250),
             casts VARCHAR(1000) ,
             country VARCHAR (150),
             date_added VARCHAR(150),
             release_year INT,
             rating VARCHAR(10),
             duration VARCHAR(15),
             listed_in VARCHAR(250),
             description VARCHAR(250)
);

COPY netflix
FROM 'E:\csv_files\netflix_titles.csv'
DELIMITER ','
CSV HEADER;

SELECT*
FROM netflix;

SELECT count(*) as total_count
FROM netflix;

SELECT 
DISTINCT TYPE
FROM netflix;


                    -- Business problem

-- 1. Count the number of Movies vs TV Shows

SELECT 
       type,
       COUNT(*) as total_count
FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows

SELECT 
    type,
    rating 
FROM
(
SELECT 
      type,
      rating,
      count(*),
      RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC ) AS ranking
 FROM netflix
 GROUP BY 1,2
)as t1
where ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE 
    type = 'Movie'
    AND
    release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
      COUNT(show_id) as total_count
    FROM netflix
    group by 1
    ORDER BY 2 DESC
    LIMIT 5;

-- 5. Identify the longest movie

SELECT*
FROM netflix
WHERE
     type = 'Movie'
     AND
     duration = (SELECT MAX(duration)FROM netflix);

-- 6.Find content added in the last 5 years

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5;

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1;

-- 10. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'




