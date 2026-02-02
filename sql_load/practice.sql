-- Problem Statement
-- our goal is to calculate two metrics for each company:
-- The number of unique skills required for their job postings.
-- The highest average annual salary among job postings that require at least one skill.
-- Your final query should return the company name, the count of unique skills, and the highest salary. 
-- For companies with no skill-related job postings, the skill count should be 0 and the salary should be null.

WITH unique_skills AS( 
    SELECT
    company_dim.company_id,
    company_dim.name,
    COUNT(DISTINCT(skills_job_dim.skill_id)) AS distintc_skills

    FROM company_dim
    LEFT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id

    GROUP BY
    company_dim.name,
    company_dim.company_id


),

max_salary AS( 
    SELECT
    MAX(job_postings_fact.salary_year_avg) AS highest_salary,
    skills_job_dim.job_id,
    COUNT(skills_job_dim.skill_id) AS skills_job_count

    
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 

    GROUP BY 
    skills_job_dim.job_id

    HAVING COUNT(skills_job_dim.skill_id) >= 1

    ORDER BY skills_job_count ASC
)


SELECT 
MAX(max_salary.highest_salary) AS high_salary,
unique_skills.name,
unique_skills.distintc_skills


FROM company_dim
LEFT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
LEFT JOIN max_salary ON job_postings_fact.job_id = max_salary.job_id
LEFT JOIN unique_skills ON company_dim.company_id = unique_skills.company_id

GROUP BY
unique_skills.name,
unique_skills.distintc_skills

ORDER BY distintc_skills ASC

