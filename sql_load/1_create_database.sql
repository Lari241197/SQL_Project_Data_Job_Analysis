SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT 

EXTRACT(MONTH FROM job_posted_date) as month_date,
count(job_id) as total_jobs

FROM 
job_postings_fact

GROUP BY
month_date

LIMIT 10;

CREATE TABLE januari AS 
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE februari AS 
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_postings_fact) = 2;

CREATE TABLE march AS 
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_postings_fact) = 3;

SELECT
job_postings_fact.company_id,
company_dim.name,
job_postings_fact.job_health_insurance,
COUNT(job_postings_fact.job_id) AS total_numero_trabajos

FROM
job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id

WHERE job_postings_fact.job_health_insurance = TRUE AND EXTRACT(QUARTER from job_postings_fact.job_posted_date) = 2

GROUP BY
  j.company_id,
  c.name,
  j.job_health_insurance

HAVING COUNT(job_postings_fact.job_id) > 0

ORDER BY
total_numero_trabajos DESC;

SELECT
job_location,
job_title_short,
CASE
    WHEN job_location = 'Anywhere' THEN 'remote'
    WHEN job_location = 'New York, NY' THEN 'local'
    ELSE 'onsite'
END AS location_category

FROM job_postings_fact;

SELECT
COUNT(job_id) AS totali_jobs,
CASE
    WHEN job_location = 'Anywhere' THEN 'remote'
    WHEN job_location = 'New York, NY' THEN 'local'
    ELSE 'onsite'
END AS location_category

FROM job_postings_fact

WHERE job_title_short = 'Data Analyst'

GROUP BY location_category;

SELECT
job_id,
job_title_short,
salary_year_avg,

CASE
    WHEN salary_year_avg < 60000 THEN 'Low Salary'
    WHEN salary_year_avg >= 60000 AND salary_year_avg < 100000 THEN 'Standard Salary'
    WHEN salary_year_avg >= 100000 THEN 'High salary'
END AS category_salary

FROM job_postings_fact

WHERE job_title_short = 'Data Analyst' AND salary_year_avg > 0

ORDER BY salary_year_avg DESC;

SELECT
job_id,
salary_year_avg,
job_title_short,
job_work_from_home,


CASE 
    WHEN job_title_short ILIKE '%Senior%' THEN 'Senior'
    WHEN job_title_short ILIKE '%Manager%' THEN 'Lead/Manager'
    WHEN job_title_short ILIKE '%Lead%' THEN 'Lead/Manager'
    ELSE 'Not specific'
END AS experience_level,

CASE 
    WHEN job_work_from_home = TRUE THEN 'Yes'
    ELSE 'No'
END AS remote_option
 
FROM job_postings_fact

WHERE salary_year_avg IS NOT NULL

ORDER BY job_id;

SELECT 
job_schedule_type,
AVG(salary_year_avg),
AVG(salary_hour_avg)

FROM 
job_postings_fact

WHERE job_posted_date::DATE > '2023-01-01'

GROUP BY job_schedule_type

ORDER BY job_schedule_type ASC;



SELECT 
COUNT (*) as totaal_aantal,
EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'AMERICAN/NEW YORK')) as maand_column

FROM 
job_postings_fact

GROUP BY
maand_column

ORDER BY
maand_column ASC;

SELECT 
COUNT (DISTINCT CASE 
    WHEN job_work_from_home = TRUE THEN company_id 
    END) as remote_jobs,
COUNT (DISTINCT CASE 
    WHEN job_work_from_home = FALSE THEN company_id 
    END) as presential_jobs

FROM job_postings_fact;

SELECT
salary_year_avg,
job_title_short,
job_id,

CASE 
    WHEN salary_year_avg <= 60000 THEN 'Low salary'
    WHEN 60000 < salary_year_avg AND salary_year_avg < 100000 THEN 'Standard salary'
    WHEN salary_year_avg >= 100000 THEN 'High salary'
END AS salary_category

FROM
job_postings_fact

WHERE
salary_year_avg IS NOT NULL and job_title_short = 'Data Analyst'

ORDER BY 
salary_year_avg DESC;

WITH remote_job_CTE AS(
    SELECT 
    COUNT(job_postings_fact.job_id) as number_of_jobs,
    skills_dim.skill_id,
    skills_dim.skills

    FROM 
    job_postings_fact

    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE
    job_work_from_home = TRUE AND 
    skills_dim.skill_id IS NOT NULL AND 
    job_title_short ='Data Analyst'

    GROUP BY
    skills_dim.skill_id,
    skills_dim.skills,
    job_postings_fact.job_work_from_home

)

SELECT 
remote_job_CTE.skill_id,
remote_job_CTE.skills,
remote_job_CTE.number_of_jobs

FROM remote_job_CTE

ORDER BY number_of_jobs DESC
LIMIT 5;

WITH problem_one AS(
    SELECT
    skills_job_dim.skill_id,
    COUNT(*) as highest_count

    FROM
    job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id

    WHERE skills_job_dim.skill_id IS NOT NULL

    GROUP BY
    skills_job_dim.skill_id
)

SELECT 
problem_one.skill_id,
skills_dim.skills,
problem_one.highest_count

FROM problem_one
LEFT JOIN skills_dim ON problem_one.skill_id = skills_dim.skill_id

ORDER BY highest_count DESC
LIMIT 5;

WITH company_ofertas AS(
    SELECT
    COUNT(job_postings_fact.job_id) as company_offers,
    company_dim.name AS nombres,
    company_dim.company_id AS identidad

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    GROUP BY
    company_dim.name,
    company_dim.company_id
)

SELECT 
company_ofertas.company_offers,
company_ofertas.nombres,
company_ofertas.identidad,

CASE 
    WHEN company_ofertas.company_offers < 10 THEN 'Small'
    WHEN company_ofertas.company_offers >= 10 AND company_ofertas.company_offers <= 50 THEN 'Medium'
    WHEN company_ofertas.company_offers > 50 THEN 'Large'
END AS size_company

FROM company_ofertas

ORDER BY identidad ASC;

WITH 
average_overall AS(
    SELECT
    AVG(salary_year_avg) as overall_average

    FROM job_postings_fact
),

companies_salary AS(
    SELECT 
    company_dim.company_id,
    company_dim.name as nombre_empresa,
    AVG(job_postings_fact.salary_year_avg) as salary_companies

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    WHERE salary_year_avg IS NOT NULL

    GROUP BY company_dim.company_id, company_dim.name
)

SELECT
average_overall.overall_average,
companies_salary.nombre_empresa,
companies_salary.salary_companies

FROM average_overall 
CROSS JOIN companies_salary

WHERE companies_salary.salary_companies > average_overall.overall_average

SELECT
job_id,
salary_year_avg,

CASE
    WHEN job_title_short ILIKE '%Senior%' THEN 'Senior'
    WHEN job_title_short ILIKE '%Manager%' THEN 'Lead/Manager'
    WHEN job_title_short ILIKE '%Lead%' THEN 'Lead/Manager'
    ELSE 'Not specified'
END AS experiences_levels,

CASE
    WHEN job_work_from_home = TRUE THEN 'Yes'
    ELSE 'No'
END AS remoote_option

FROM 
job_postings_fact

WHERE 
salary_year_avg IS NOT NULL

ORDER BY
job_id;

SELECT 
company_dim.name,
EXTRACT(QUARTER FROM job_posted_date) as quarter_date,
count(*) AS totale_aantal_jobs

FROM 
job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE
job_health_insurance = TRUE AND EXTRACT(QUARTER FROM job_posted_date) > 2

GROUP BY
company_dim.name,
quarter_date

HAVING
count(*) > 0

ORDER BY
totale_aantal_jobs DESC;

SELECT
company_dim.name,
EXTRACT(QUARTER FROM job_posted_date) AS quarter_two,
count(*) AS totale_aantal_werk

FROM job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE
job_health_insurance = TRUE AND EXTRACT(QUARTER FROM job_posted_date) = '2'

GROUP BY
company_dim.name,
quarter_two

ORDER BY
totale_aantal_werk DESC;

SELECT 
company_dim.name,
count(*) as trabajos

FROM job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE 
job_posted_date::DATE BETWEEN '2023-01-01' AND DATE '2023-12-31'

GROUP BY
company_dim.name

ORDER BY
trabajos DESC

LIMIT 5;

SELECT 
company_dim.name,
ROUND(AVG(salary_year_avg), 3) as average_salaris,
count(*) as postings

FROM 
job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

GROUP BY
company_dim.name

HAVING
count(*) > 10 AND AVG(salary_year_avg) IS NOT NULL

ORDER BY
average_salaris DESC;

SELECT 
SUM (CASE WHEN job_schedule_type = 'Full-time' THEN 1 ELSE 0 END) as full_time_job,
SUM (CASE WHEN job_schedule_type = 'Part-time' THEN 1 ELSE 0 END) as part_time_jobs,
company_dim.name

FROM job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id

WHERE job_posted_date::DATE BETWEEN DATE '2023-01-01' AND DATE '2023-03-31'

GROUP BY
company_dim.name

ORDER BY full_time_job DESC, part_time_jobs DESC;

SELECT
company_dim.name,
AVG(salary_hour_avg) as avg_hour_salary

FROM
job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE job_posted_date::DATE BETWEEN '2023-01-01' AND DATE '2023-12-31'
GROUP BY
company_dim.name

HAVING AVG(salary_hour_avg) > 40 AND
SUM(CASE WHEN job_health_insurance THEN 1 END) > 0 

ORDER BY
avg_hour_salary DESC;

SELECT
AVG(salary_year_avg) as avg_year_salary,
EXTRACT(QUARTER FROM job_posted_date) AS quarter_datum

FROM
job_postings_fact

WHERE job_posted_date::DATE BETWEEN '2023-01-01' AND DATE '2023-12-31'

GROUP BY
quarter_datum;

SELECT
company_dim.name,
count(*) AS total_trabajos

FROM
job_postings_fact
 
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE job_health_insurance = 'FALSE' AND job_posted_date::DATE BETWEEN '2023-01-01' AND DATE '2023-12-31'

GROUP BY
company_dim.name

HAVING count(*) > 0

ORDER BY
total_trabajos DESC;

WITH tabel_skills AS(
    SELECT
    skills_job_dim.skill_id,
    count(*) as total_skills

    FROM job_postings_fact

    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id

    WHERE job_postings_fact.job_work_from_home = TRUE

    GROUP BY
    skills_job_dim.skill_id

)

SELECT
skills_dim.skills,
tabel_skills.total_skills,
tabel_skills.skill_id

FROM tabel_skills

INNER JOIN skills_dim ON tabel_skills.skill_id = skills_dim.skill_id

ORDER BY total_skills DESC

LIMIT 5;

WITH 
gemiddeld_salaris_bedrijven AS (
    SELECT
    AVG(job_postings_fact.salary_year_avg) AS avg_salary_company,
    company_dim.name,
    company_dim.company_id

    FROM job_postings_fact

    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    WHERE salary_year_avg IS NOT NULL

    GROUP BY
    company_dim.company_id,
    company_dim.name

),

overall_gemiddeld AS (
    SELECT
    AVG(salary_year_avg) AS avg_salary_overall

    FROM job_postings_fact
)

SELECT 
gemiddeld_salaris_bedrijven.name,
gemiddeld_salaris_bedrijven.company_id,
gemiddeld_salaris_bedrijven.avg_salary_company

FROM gemiddeld_salaris_bedrijven

CROSS JOIN overall_gemiddeld 

WHERE gemiddeld_salaris_bedrijven.avg_salary_company > overall_gemiddeld.avg_salary_overall;

WITH 

average_data_scientst AS (
    SELECT
    AVG(salary_year_avg) as gemiddeld_salaris_data

    FROM
    job_postings_fact

    WHERE job_postings_fact.job_title_short = 'Data Scientist'
),

average_salary_companies AS(
    SELECT
    AVG(salary_year_avg) as average_salary,
    company_dim.name,
    company_dim.company_id

    FROM job_postings_fact

    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    GROUP BY
    company_dim.company_id,
    company_dim.name

)

SELECT
average_salary_companies.name,
average_salary_companies.company_id,
average_salary_companies.average_salary,
average_data_scientst.gemiddeld_salaris_data

FROM average_salary_companies

CROSS JOIN average_data_scientst

WHERE average_data_scientst.gemiddeld_salaris_data < average_salary_companies.average_salary

ORDER BY average_salary_companies.average_salary ASC;

WITH unique_companies AS(
    SELECT
    job_postings_fact.company_id,
    COUNT(DISTINCT(job_postings_fact.job_title)) AS aantal_job

    FROM job_postings_fact
 
    GROUP BY 
    job_postings_fact.company_id

)

SELECT
unique_companies.company_id,
unique_companies.aantal_job,
company_dim.name

FROM unique_companies
INNER JOIN company_dim ON unique_companies.company_id = company_dim.company_id

ORDER BY aantal_job DESC

LIMIT 10;

WITH countries AS(

    SELECT
    ROUND(AVG(salary_year_avg),2) AS avg_salary_countries,
    job_country

    FROM
    job_postings_fact

    GROUP BY
    job_country

)

SELECT
job_id,
job_title,
company_dim.name,
salary_year_avg,
EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month_jobs,
avg_salary_countries,

CASE
    WHEN avg_salary_countries > salary_year_avg THEN 'Lower'
    WHEN avg_salary_countries = salary_year_avg THEN 'Equal'
    ELSE 'Higher'
END AS category_salaries

FROM job_postings_fact
INNER JOIN countries ON job_postings_fact.job_country = countries.job_country
INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id;


