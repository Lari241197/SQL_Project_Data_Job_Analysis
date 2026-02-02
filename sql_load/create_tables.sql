CREATE TABLE public.practice_table (
    name_practice TEXT,
    id_practice INT PRIMARY KEY,
    country_practice TEXT,
    salary_practice NUMERIC,
    FOREIGN KEY (country_practice) REFERENCES 
);

CREATE TABLE practicar AS
SELECT * FROM job_postings_fact
WHERE job_postings_fact.job_title_short ILIKE '%Analyst%';;

SELECT * FROM practicar

DROP TABLE practicar;

CREATE TABLE februari AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 2;

CREATE TABLE march AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 3;


SELECT
quarter_jobs.job_title_short,
quarter_jobs.job_location,
quarter_jobs.salary_year_avg,
quarter_jobs.job_posted_date::DATE

FROM 
( 
    SELECT * FROM januari
    UNION ALL
    SELECT * FROM februari
    UNION ALL 
    SELECT * FROM march
) AS quarter_jobs

WHERE quarter_jobs.salary_year_avg > 70000

ORDER BY quarter_jobs.salary_year_avg DESC;


WITH salary_information AS (
    SELECT 
    job_id,
    CASE 
        WHEN salary_year_avg IS NULL AND salary_hour_avg IS NULL THEN 'Without salary info'
        WHEN salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL THEN 'With salary info'
    END AS salary_info

    FROM job_postings_fact
) 


SELECT
job_postings_fact.job_id,
job_postings_fact.job_title,
salary_information.salary_info

FROM job_postings_fact
LEFT JOIN salary_information ON job_postings_fact.job_id = salary_information.job_id;


SELECT
job_id,
job_title,
'Without salary info' AS salary_infor 

FROM job_postings_fact
WHERE salary_hour_avg IS NULL 
AND salary_year_avg IS NULL

UNION ALL

SELECT 
job_id,
job_title,
'With salary info' AS salary_infor

FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
OR salary_year_avg IS NOT NULL;

-- Retrieve the job id, job title short, job location, job via, 
-- skill and skill type for each job posting from the first quarter 
-- (January to March). Using a subquery to combine job postings from 
-- the first quarter (these tables were created in the Advanced Section 
-- Practice Problem 6 Video) Only include postings with an average yearly 
-- salary greater than $70,000.

SELECT
job_postings_fact.job_id,
job_postings_fact.job_title_short,
job_postings_fact.job_location,
job_postings_fact.job_via,
skills_job_dim.skill_id,
skills_dim.skill,

FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 1;


SELECT * 

FROM 
(
    SELECT
    januari.job_id,
    januari.job_title_short,
    januari.job_location,
    januari.job_via,
    januari.salary_year_avg,
    ARRAY_AGG(skills_job_dim.skill_id) AS skill_ids


    FROM januari
    LEFT JOIN skills_job_dim ON januari.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    GROUP BY januari.job_id,
    januari.job_title_short,
    januari.job_location,
    januari.job_via,
    januari.salary_year_avg

    UNION ALL

    SELECT
    februari.job_id,
    februari.job_title_short,
    februari.job_location,
    februari.job_via,
    februari.salary_year_avg,
    ARRAY_AGG(skills_job_dim.skill_id) AS skill_ids

    FROM februari
    LEFT JOIN skills_job_dim ON februari.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    GROUP BY 
    februari.job_id,
    februari.job_title_short,
    februari.job_location,
    februari.job_via,
    februari.salary_year_avg

    UNION ALL

    SELECT
    march.job_id,
    march.job_title_short,
    march.job_location,
    march.job_via,
    march.salary_year_avg,
    ARRAY_AGG(skills_job_dim.skill_id) AS skill_ids


    FROM march
    LEFT JOIN skills_job_dim ON march.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    GROUP BY 
    march.job_id,
    march.job_title_short,
    march.job_location,
    march.job_via,
    march.salary_year_avg

) AS jobs_first_quarter

WHERE jobs_first_quarter.salary_year_avg > 70000;

