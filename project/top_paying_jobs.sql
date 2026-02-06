-- top paying jobs


SELECT
    job_title,
    salary_year_avg,
    job_id,
    job_posted_date,
    job_location,
    job_work_from_home,
    company_dim.name

FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE
job_title_short = 'Data Analyst' AND 
job_work_from_home = 'True' AND
salary_year_avg IS NOT NULL


ORDER BY salary_year_avg DESC

LIMIT 10
