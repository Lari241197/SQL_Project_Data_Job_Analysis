

WITH max_salary_per_skill AS (
    SELECT
    MAX(job_postings_fact.salary_year_avg),
    skills_job_dim.skill_id

    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id

    WHERE job_postings_fact.salary_year_avg IS NOT NULL AND
    skills_job_dim.skill_id IS NOT NULL

    GROUP BY
    skills_job_dim.skill_id

    ORDER BY MAX(job_postings_fact.salary_year_avg) DESC
), 

skills_data_analyst AS(
    SELECT
    skills_job_dim.skill_id,
    COUNT(skills_job_dim.skill_id) AS total_skills

    FROM skills_job_dim
    LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id

    WHERE job_postings_fact.job_work_from_home = 'TRUE' AND
    job_postings_fact.job_title_short = 'Data Analyst'

    GROUP BY skills_job_dim.skill_id

    ORDER BY total_skills DESC
)

SELECT
skills_data_analyst.skill_id,
skills_data_analyst.total_skills,
skills_dim.skills

FROM skills_data_analyst
INNER JOIN skills_dim ON skills_data_analyst.skill_id = skills_dim.skill_id

ORDER BY total_skills DESC
