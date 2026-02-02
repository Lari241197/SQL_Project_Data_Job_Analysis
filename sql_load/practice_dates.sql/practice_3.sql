WITH average_total_salary AS(
    SELECT
    AVG(job_postings_fact.salary_year_avg) AS average_total

    FROM job_postings_fact
),

average_companies_salary AS(

    SELECT
    company_dim.name,
    company_dim.company_id,
    AVG(job_postings_fact.salary_year_avg) AS average_companies

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    GROUP BY
    company_dim.name,
    company_dim.company_id

)

SELECT
ROUND(average_companies_salary.average_companies, 2),
average_companies_salary.name,
CASE
    WHEN average_companies > average_total THEN 'Above market'
    WHEN average_companies < average_total THEN 'Below market'
END AS salary_category

FROM average_companies_salary
CROSS JOIN average_total_salary

WHERE average_companies_salary.average_companies IS NOT NULL 