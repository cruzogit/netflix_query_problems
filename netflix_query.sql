SELECT * FROM public.netflix;
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

select type,title from netflix
group by type,title;


select count(*) as total_count from  netflix;

--1. Count the Number of Movies vs TV Shows
select type,count(*) as count_total from netflix
group by type;


--2. Find the Most Common Rating for Movies and TV Shows
select type,rating,count(*) as count_total from netflix
group by type,rating 
order by 3 desc ;

SELECT type,
			rating FROM
	(SELECT type,
		rating ,
		count(*),
        RANK() OVER (PARTITION BY type ORDER BY count(*) DESC) AS ranking
	from netflix
	group by 1,2) as t1
	where  ranking = 1;

--3. List All Movies Released in a Specific Year (e.g., 2020)

select title,type ,release_year from netflix
where type = 'Movie'
and 
release_year ='2020';

--4. Find the Top 5 Countries with the Most Content on Netflix

select * from netflix;
select country, count(*)as total_count from netflix
group by country 
order by  total_count desc
limit(5);
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
	order by total_content desc
	limit (5)
	;

select * from netflix;
select listed_in, count(*)as total_count from netflix
group by listed_in 
order by  total_count desc
limit(5);

--Identify the Longest Movie
select type, duration from netflix
where 
type = 'Movie'
and 
duration = (select max (duration)from netflix);


SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;


--6. Find Content Added in the Last 5 Years
SELECT
    title,
    type,
    date_added
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years'
ORDER BY TO_DATE(date_added, 'Month DD, YYYY') DESC;

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
 select type, director from netflix
 where director like '%Rajiv Chilaka%';
 
--8. List All TV Shows with More Than 5 Seasons

select * from netflix ;
where type = 'TV Show' ;

SELECT *
FROM netflix
WHERE 
	type = 'TV Show'
	and
	SPLIT_PART(duration, ' ', 1)::INT > 5
;
--9. Count the Number of Content Items in Each Genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--10.Find each year and the average numbers of content release in India on netflix
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


--11. List All Movies that are Document


  select listed_in 
  from netflix
  where listed_in like '%Documentaries%';

 --12. Find All Content Without a Director

 SELECT director 
FROM netflix
WHERE director IS NULL;

select * from netflix;
  --13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select casts ,release_year from netflix
where casts like '%Salman Khan%'
and release_year > 2014;
--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select unnest(string_to_array(casts,',')) as actors,
		count(*) as total_count
		from netflix
		group by 1;


SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10; 
--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



	