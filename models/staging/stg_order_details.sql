{{ config(
    materialized='view',
    schema='staging',
) }}



WITH source AS (
    SELECT * FROM {{ ref('src_order_details') }}
),

renamed AS (
    SELECT
        ORDER_NUMBER AS order_number,
        PRODUCT_CODE AS product_code,
        CAST(QUANTITY_ORDERED AS INTEGER) AS quantity_ordered,
        CAST(PRICE_EACH AS DECIMAL(10,2)) AS price_each,
        ORDER_LINE_NUMBER AS order_line_number,
        CAST(QUANTITY_ORDERED AS INTEGER) * CAST(PRICE_EACH AS DECIMAL(10,2)) AS total_price,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
)

SELECT * FROM renamed
ORDER BY order_number, order_line_number
