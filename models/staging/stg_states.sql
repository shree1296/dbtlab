{{ config(
    materialized='view',
    schema='staging',
) }}



WITH states AS (
    SELECT 
        STATE_CODE AS STATE_ID,  -- Renaming for consistency  
        STATE_NAME,
        COUNTRY_CODE  -- Matches with stg_countries
    FROM {{ ref('src_states') }}
)

SELECT * FROM states
