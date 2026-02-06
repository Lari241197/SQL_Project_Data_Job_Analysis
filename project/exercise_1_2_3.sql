
-- 1.

WITH highest_salary AS (
    SELECT
    job_id,
    job_title,
    salary_year_avg,
    company_dim.name

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = 'True'

    ORDER BY salary_year_avg DESC
), 

-- 2. 

skills_highest_salary AS(
    SELECT
    highest_salary.job_id,
    highest_salary.job_title,
    highest_salary.salary_year_avg,
    highest_salary.name,
    skills_job_dim.skill_id,
    skills_dim.skills

    FROM highest_salary
    LEFT JOIN skills_job_dim ON highest_salary.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE skills_job_dim.skill_id IS NOT NULL

    ORDER BY highest_salary.salary_year_avg DESC
)


-- 3.
WITH in_demand_skills AS(
    SELECT 
    COUNT(skills_job_dim.skill_id) AS total_skills,
    skills_job_dim.skill_id,
    skills_dim.skills

    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_work_from_home = 'True' AND
    skills_job_dim.skill_id IS NOT NULL AND
    salary_year_avg IS NOT NULL 

    GROUP BY skills_job_dim.skill_id,
    skills_dim.skills

),

-- 4.
top_skills_based_salary AS(
    SELECT
    skills_dim.skills,
    skills_job_dim.skill_id,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS average_salary_skill

    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE salary_year_avg IS NOT NULL AND
    skills_job_dim.skill_id IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'True'

    GROUP BY
    skills_job_dim.skill_id,
    skills_dim.skills

)

SELECT 
in_demand_skills.skills,
in_demand_skills.skill_id,
in_demand_skills.total_skills,
top_skills_based_salary.average_salary_skill

FROM in_demand_skills
LEFT JOIN top_skills_based_salary ON in_demand_skills.skill_id = top_skills_based_salary.skill_id

WHERE in_demand_skills.total_skills > 10 

ORDER BY top_skills_based_salary.average_salary_skill DESC,
in_demand_skills.total_skills DESC
        