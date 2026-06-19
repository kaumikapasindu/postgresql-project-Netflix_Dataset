# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(6),
    type         VARCHAR(10),
    title        VARCHAR(150),
    director     VARCHAR(250),
    casts        VARCHAR(1000),
    country      VARCHAR(150),
    date_added   VARCHAR(155),
    release_year INT,
    rating       VARCHAR(10),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(250)
);
```

## Data inser in to table
``` sql
COPY netflix
FROM 'E:\csv_files\netflix_titles.csv'
DELIMITER ','
CSV HEADER;
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
       type,
       COUNT(*) as total_count
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql

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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
 3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE 
    type = 'Movie'
    AND
    release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
      COUNT(show_id) as total_count
    FROM netflix
    group by 1
    ORDER BY 2 DESC
    LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT*
FROM netflix
WHERE
     type = 'Movie'
     AND
     duration = (SELECT MAX(duration)FROM netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.


### 10. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

