{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH cleaned_products AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['PRODUCT_CODE']) }} AS PRODUCT_KEY,
        PRODUCT_CODE,
        TRIM(UPPER(PRODUCT_NAME)) AS PRODUCT_NAME,
        TRIM(UPPER(PRODUCT_LINE)) AS CATEGORY,  -- Fixed column reference
        TRIM(UPPER(PRODUCT_VENDOR)) AS SUPPLIER_NAME, -- Replaced SUPPLIER_ID with PRODUCT_VENDOR
        CAST(BUY_PRICE AS DECIMAL(10,2)) AS PRICE,
        QUANTITY_IN_STOCK AS STOCK_QUANTITY,
        CURRENT_TIMESTAMP AS LOADED_AT
    FROM {{ ref('stg_products') }}
    WHERE PRODUCT_CODE IS NOT NULL
)

SELECT 
    PRODUCT_KEY,
    PRODUCT_CODE AS PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    SUPPLIER_NAME,  -- Updated column reference
    PRICE,
    STOCK_QUANTITY,
    LOADED_AT
FROM cleaned_products