{{ config(
    materialized='view',
    schema='staging',
) }}




WITH source AS (
    SELECT * FROM {{ ref('src_employees') }}
),

renamed AS (
    SELECT 
        EMPLOYEE_NUMBER AS employee_number,
        INITCAP(CONCAT(FIRST_NAME, ' ', LAST_NAME)) AS employee_name,
        TRIM(JOB_TITLE) AS job_title,
        LOWER(EMAIL) AS employee_email,
        NULLIF(EXTENSION, '') AS extension,
        OFFICE_CODE AS office_code,
        CAST(REPORTS_TO AS INTEGER) AS reports_to,
        SPLIT_PART(EMAIL, '@', 2) AS email_domain,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
)

SELECT * FROM renamed
