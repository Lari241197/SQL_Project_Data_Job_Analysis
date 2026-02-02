WITH countries AS (
    SELECT
    job_postings_fact.job_location,
    COUNT(DISTINCT(job_postings_fact.company_id)) AS countings_countries

    FROM job_postings_fact
 
    GROUP BY
    job_location
),

jobs AS (
    SELECT
    job_postings_fact.job_location,
    COUNT((job_postings_fact.job_id)) AS countings_jobs

    FROM job_postings_fact

    GROUP BY
    job_location
),

highest_salary AS (
    SELECT
    job_postings_fact.job_location,
    MAX(job_postings_fact.salary_year_avg) AS max_salary

    FROM job_postings_fact

    GROUP BY
    job_location
)

SELECT 
countries.job_location,
countries.countings_countries,
jobs.countings_jobs,
highest_salary.max_salary

FROM countries
LEFT JOIN jobs ON countries.job_location = jobs.job_location
LEFT JOIN highest_salary ON countries.job_location = highest_salary.job_location

LIMIT 100