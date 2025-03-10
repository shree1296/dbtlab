{{ config(
    materialized='view',
    schema='staging',
) }}


WITH countries AS (
    SELECT 
        COUNTRY_CODE AS COUNTRY_ID,  -- Renaming for consistency
        COUNTRY_NAME
    FROM {{ ref('src_countries') }}
)

SELECT * FROM countries
