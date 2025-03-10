{{ config(
    materialized='view',
    schema='staging',
) }}


WITH source AS (
    SELECT * FROM {{ ref('src_products') }}
),

deduplicated AS (
    SELECT
        PRODUCT_CODE AS product_code,
        PRODUCT_NAME AS product_name,
        PRODUCT_LINE AS product_line,
        PRODUCT_SCALE AS product_scale,
        PRODUCT_VENDOR AS product_vendor,
        PRODUCT_DESCRIPTION AS product_description,
        QUANTITY_IN_STOCK AS quantity_in_stock,
        CAST(BUY_PRICE AS DECIMAL(15,2)) AS buy_price,
        CAST(MSRP AS DECIMAL(15,2)) AS msrp,
        ROW_NUMBER() OVER (
            PARTITION BY PRODUCT_CODE 
            ORDER BY CURRENT_TIMESTAMP() DESC, PRODUCT_NAME, PRODUCT_CODE
        ) AS rn,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
)

SELECT
    product_code,
    product_name,
    product_line,
    product_scale,
    product_vendor,
    product_description,
    quantity_in_stock,
    buy_price,
    msrp,
    loaded_at
FROM deduplicated
WHERE rn = 1
