WITH companies AS (
    SELECT
    job_postings_fact.job_title_short,
    COUNT(DISTINCT(company_id)) AS companies_hiring

    FROM job_postings_fact

    GROUP BY
    job_title_short
),

salary AS ( 
    SELECT
    job_postings_fact.job_title_short,
    MAX(salary_year_avg) AS max_salary
 
    FROM job_postings_fact

    GROUP BY
    job_title_short
)

SELECT
companies.job_title_short,
companies.companies_hiring,
salary.max_salary

FROM companies
LEFT JOIN salary ON companies.job_title_short = salary.job_title_short
