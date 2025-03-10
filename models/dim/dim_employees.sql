{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH employees AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['employee_number']) }} AS employee_id,
        employee_number,
        employee_name,
        job_title,
        employee_email,
        office_code,
        reports_to
    FROM {{ ref('stg_employees') }}
)

SELECT * FROM employees
ORDER BY employee_number
