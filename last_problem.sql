-- Analyze the monthly demand for skills by counting the number of job postings for each skill in the first quarter 
-- (January to March), utilizing data from separate tables for each month. Ensure to include skills from all job 
-- postings across these months. The tables for the first quarter job postings were created in Practice Problem 6.


SELECT 
COUNT(total_jobs),
skill_id,
skills

FROM (

    SELECT
    (januari.job_id) AS total_jobs,
    januari.job_posted_date::DATE,
    skills_job_dim.skill_id,
    skills_dim.skills

    FROM januari
    LEFT JOIN skills_job_dim ON januari.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id



    UNION ALL

    SELECT
    (februari.job_id) AS total_jobs,
    februari.job_posted_date::DATE,
    skills_job_dim.skill_id,
    skills_dim.skills

    FROM februari
    LEFT JOIN skills_job_dim ON februari.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id



    UNION ALL

    SELECT
    (march.job_id) AS total_jobs,
    march.job_posted_date::DATE,
    skills_job_dim.skill_id,
    skills_dim.skills

    FROM march
    LEFT JOIN skills_job_dim ON march.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    GROUP BY
    skills_job_dim.skill_id,
    march.job_posted_date,
    skills_dim.skills
) AS quarter_skills

GROUP BY skill_id,
skills
ORDER BY skill_id ASC

