{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH customers AS (
    SELECT 
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CONTACT_LAST_NAME,
        CONTACT_FIRST_NAME,
        PHONE,
        ADDRESS_LINE1,
        ADDRESS_LINE2,
        CUSTOMER_CITY,
        CUSTOMER_STATE,
        CUSTOMER_POSTAL_CODE,
        CUSTOMER_COUNTRY,
        CUSTOMER_CREDIT_LIMIT,
        LOADED_AT  -- Assuming we have a timestamp to deduplicate correctly
    FROM raw_staging.stg_customers
),
cities AS (
    SELECT 
        CITY_NAME,
        STATE_CODE,
        COUNTRY_CODE
    FROM raw_staging.stg_cities
),
deduplicated_customers AS (
    SELECT 
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CONTACT_LAST_NAME,
        CONTACT_FIRST_NAME,
        PHONE,
        ADDRESS_LINE1,
        ADDRESS_LINE2,
        CUSTOMER_CITY,
        CUSTOMER_STATE,
        CUSTOMER_POSTAL_CODE,
        CUSTOMER_COUNTRY,
        CUSTOMER_CREDIT_LIMIT,
        {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID']) }} AS CUSTOMER_KEY,
        ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOADED_AT DESC) AS row_num  -- Latest record first
    FROM customers
)
SELECT 
    C.CUSTOMER_KEY,
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.CONTACT_LAST_NAME,
    C.CONTACT_FIRST_NAME,
    C.PHONE,
    C.ADDRESS_LINE1,
    C.ADDRESS_LINE2,
    C.CUSTOMER_CITY,
    C.CUSTOMER_STATE,
    C.CUSTOMER_POSTAL_CODE,
    C.CUSTOMER_COUNTRY,
    C.CUSTOMER_CREDIT_LIMIT
FROM deduplicated_customers C
LEFT JOIN cities CT
    ON C.CUSTOMER_CITY = CT.CITY_NAME 
    AND C.CUSTOMER_STATE = CT.STATE_CODE 
    AND C.CUSTOMER_COUNTRY = CT.COUNTRY_CODE
WHERE row_num = 1  -- Ensures only one row per CUSTOMER_ID
