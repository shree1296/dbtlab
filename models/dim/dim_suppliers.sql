{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH distinct_suppliers AS (
    SELECT DISTINCT 
        TRIM(UPPER(PRODUCT_VENDOR)) AS SUPPLIER_NAME
    FROM {{ ref('stg_products') }}
    WHERE PRODUCT_VENDOR IS NOT NULL
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['SUPPLIER_NAME']) }} AS SUPPLIER_KEY,  -- Ensuring consistency with other dimension tables
    SUPPLIER_NAME,
    'Unknown Contact' AS CONTACT_NAME,  -- Placeholder for future enrichment
    'Unknown Country' AS COUNTRY,  -- Placeholder for future enrichment
    CURRENT_TIMESTAMP AS LOADED_AT  -- Tracking refresh time
FROM distinct_suppliers
ORDER BY SUPPLIER_NAME
