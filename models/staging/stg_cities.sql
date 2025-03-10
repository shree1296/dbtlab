{{ config(
    materialized='view',
    schema='staging',
) }}


WITH cities AS (
    SELECT 
        CITY_ID,
        CITY_NAME,
        STATE_CODE,   -- Matches src_states
        COUNTRY_CODE  -- Matches src_countries
    FROM {{ ref('src_cities') }}
)
SELECT * FROM cities
