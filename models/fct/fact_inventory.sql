{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH inventory AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['product_code']) }} AS inventory_id,
        product_code AS product_id,
        quantity_in_stock,
        buy_price,
        (quantity_in_stock * buy_price) AS total_inventory_value,
        CURRENT_DATE AS snapshot_date,
        CAST(TO_CHAR(CURRENT_DATE, 'YYYYMMDD') AS NUMBER(18,0)) AS date_id
    FROM {{ ref('stg_products') }}
)

SELECT * FROM inventory
ORDER BY product_id
