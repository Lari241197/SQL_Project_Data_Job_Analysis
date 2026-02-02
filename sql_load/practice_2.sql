
SELECT
COUNT(DISTINCT(job_postings_fact.job_id)) as total_aantal_jobs,
COUNT(DISTINCT(skills_job_dim.skill_id)) AS total_skills,
company_dim.name,
company_dim.company_id

FROM company_dim
LEFT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id


GROUP BY
company_dim.company_id,
company_dim.name

ORDER BY total_aantal_jobs ASC