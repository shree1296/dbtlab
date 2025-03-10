{{ config(
    materialized='view',
    schema='staging',
) }}

WITH source AS (
    SELECT * FROM {{ ref('src_customers') }}
),

countries AS (
    SELECT 
        COUNTRY_ID,
        COUNTRY_NAME
    FROM {{ ref('stg_countries') }}
),

states AS (
    SELECT 
        STATE_ID,
        STATE_NAME
    FROM {{ ref('stg_states') }}
),

renamed AS (
    SELECT 
        CUSTOMER_ID AS customer_id,
        UPPER(CUSTOMER_NAME) AS customer_name,
        INITCAP(CONTACT_LAST_NAME) AS contact_last_name,
        INITCAP(CONTACT_FIRST_NAME) AS contact_first_name,
        PHONE AS phone,
        NULLIF(ADDRESS_LINE1, '') AS address_line1,
        NULLIF(ADDRESS_LINE2, '') AS address_line2,
        INITCAP(CITY) AS customer_city,
        s.STATE_ID AS state_id, 
        NULLIF(INITCAP(STATE), '') AS customer_state,
        NULLIF(POSTAL_CODE, '') AS customer_postal_code,
        c.COUNTRY_ID AS country_id, 
        INITCAP(COUNTRY) AS customer_country,
        SALES_REP_EMPLOYEE_NUMBER AS sales_rep_id,
        CAST(CREDIT_LIMIT AS DECIMAL(15,2)) AS customer_credit_limit,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
    LEFT JOIN countries c ON INITCAP(source.COUNTRY) = c.COUNTRY_NAME  
    LEFT JOIN states s ON INITCAP(source.STATE) = s.STATE_NAME  
)

SELECT * FROM renamed
