-- top skills based on salary for data analyst
WITH highest_salaries AS(
    SELECT
    job_postings_fact.job_id,
    job_title,
    job_title_short,
    job_postings_fact.salary_year_avg

    FROM job_postings_fact

    WHERE salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'True'

    ORDER BY salary_year_avg DESC

), max_salary_per_skill AS (
    SELECT
    MAX(job_postings_fact.salary_year_avg) AS max_salary,
    skills_job_dim.skill_id

    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id

    WHERE job_postings_fact.salary_year_avg IS NOT NULL AND
    skills_job_dim.skill_id IS NOT NULL

    GROUP BY
    skills_job_dim.skill_id

    ORDER BY MAX(job_postings_fact.salary_year_avg) DESC
)


SELECT
highest_salaries.job_title,
highest_salaries.job_id,
max_salary_per_skill.max_salary,
company_dim.name,
max_salary_per_skill.skill_id,
skills_dim.skills

FROM highest_salaries
LEFT JOIN job_postings_fact ON highest_salaries.job_id = job_postings_fact.job_id
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
LEFT JOIN skills_job_dim ON highest_salaries.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id


WHERE skills_dim.skill_id IS NOT NULL


ORDER BY highest_salaries.salary_year_avg DESC 
LIMIT 10
