{{ config(
    materialized='view',
    schema='staging',
) }}




WITH source AS (
    SELECT * FROM {{ ref('src_office') }}
),

renamed AS (
    SELECT 
        OFFICE_CODE AS office_code,
        INITCAP(CITY) AS city,
        NULLIF(STATE, '') AS state,
        INITCAP(COUNTRY) AS country,
        NULLIF(POSTAL_CODE, '') AS postal_code,
        COALESCE(INITCAP(TERRITORY), 'Unknown') AS territory,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
)

SELECT * FROM renamed
