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

)

SELECT
highest_salaries.job_title,
highest_salaries.job_id,
highest_salaries.salary_year_avg,
company_dim.name,
STRING_AGG(skills_dim.skill_id::text, ',') AS skill_ids,
STRING_AGG(skills_dim.skills, ',') AS skill

FROM highest_salaries
LEFT JOIN job_postings_fact ON highest_salaries.job_id = job_postings_fact.job_id
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
LEFT JOIN skills_job_dim ON highest_salaries.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id


WHERE skills_dim.skill_id IS NOT NULL

GROUP BY
highest_salaries.job_title,
highest_salaries.job_id,
highest_salaries.salary_year_avg,
company_dim.name

ORDER BY highest_salaries.salary_year_avg DESC 
LIMIT 10

/* 

From highest to lowest frequency:
SQL → by far the most requested skill
Python
Tableau
R
Excel
[
  {
    "job_title": "Associate Director- Data Insights",
    "job_id": 552322,
    "salary_year_avg": "255829.5",
    "name": "AT&T",
    "skill_ids": "0,1,5,74,75,76,93,95,102,181,182,183,196",
    "skill": "sql,python,r,azure,databricks,aws,pandas,pyspark,jupyter,excel,tableau,power bi,powerpoint"
  },
  {
    "job_title": "Data Analyst, Marketing",
    "job_id": 99305,
    "salary_year_avg": "232423.0",
    "name": "Pinterest Job Advertisements",
    "skill_ids": "0,1,5,97,182",
    "skill": "sql,python,r,hadoop,tableau"
  },
  {
    "job_title": "Data Analyst (Hybrid/Remote)",
    "job_id": 1021647,
    "salary_year_avg": "217000.0",
    "name": "Uclahealthcareers",
    "skill_ids": "0,23,79,182,215",
    "skill": "sql,crystal,oracle,tableau,flow"
  },
  {
    "job_title": "Principal Data Analyst (Remote)",
    "job_id": 168310,
    "salary_year_avg": "205000.0",
    "name": "SmartAsset",
    "skill_ids": "0,1,8,80,93,94,181,182,220",
    "skill": "sql,python,go,snowflake,pandas,numpy,excel,tableau,gitlab"
  },
  {
    "job_title": "Director, Data Analyst - HYBRID",
    "job_id": 731368,
    "salary_year_avg": "189309.0",
    "name": "Inclusively",
    "skill_ids": "0,1,74,76,79,80,182,183,189,211,218,219,233,234",
    "skill": "sql,python,azure,aws,oracle,snowflake,tableau,power bi,sap,jenkins,bitbucket,atlassian,jira,confluence"
  },
  {
    "job_title": "Principal Data Analyst, AV Performance Analysis",
    "job_id": 310660,
    "salary_year_avg": "189000.0",
    "name": "Motional",
    "skill_ids": "0,1,5,210,218,219,233,234",
    "skill": "sql,python,r,git,bitbucket,atlassian,jira,confluence"
  },
  {
    "job_title": "Principal Data Analyst",
    "job_id": 1749593,
    "salary_year_avg": "186000.0",
    "name": "SmartAsset",
    "skill_ids": "0,1,8,80,93,94,181,182,220",
    "skill": "sql,python,go,snowflake,pandas,numpy,excel,tableau,gitlab"
  },
  {
    "job_title": "ERM Data Analyst",
    "job_id": 387860,
    "salary_year_avg": "184000.0",
    "name": "Get It Recruit - Information Technology",
    "skill_ids": "0,1,5",
    "skill": "sql,python,r"
  },
  {
    "job_title": "Azure Data Python Consultant - contract to HIRE - Citizen or Perm...",
    "job_id": 987523,
    "salary_year_avg": "170000.0",
    "name": "Kelly Science, Engineering, Technology & Telecom",
    "skill_ids": "0,1,74,75,183",
    "skill": "sql,python,azure,databricks,power bi"
  },
  {
    "job_title": "DTCC Data Analyst",
    "job_id": 1781684,
    "salary_year_avg": "170000.0",
    "name": "Robert Half",
    "skill_ids": "4,8,181",
    "skill": "java,go,excel"
  }
]

*/