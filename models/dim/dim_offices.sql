{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH offices AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['office_code']) }} AS office_id,
        office_code,
        city,
        COALESCE(state, 'Unknown') AS state,
        country,
        territory AS region,
        postal_code
    FROM {{ ref('stg_office') }}
)

SELECT * FROM offices
ORDER BY office_code
