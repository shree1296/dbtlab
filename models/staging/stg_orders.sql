{{ config(
    materialized='view',
    schema='staging',
) }}

WITH source AS (
    SELECT * FROM {{ ref('src_orders') }}
)

SELECT
    ORDER_NUMBER AS order_number,
    ORDER_DATE AS order_date,
    REQUIRED_DATE AS required_date,
    COALESCE(SHIPPED_DATE, DATEADD(DAY, 5, ORDER_DATE)) AS shipped_date,
    STATUS AS order_status,
    COALESCE(COMMENTS, 'No Comments') AS comments,
    TRY_CAST(CUSTOMER_ID AS NUMBER) AS customer_id,  -- Ensure numeric CUSTOMER_ID
    CURRENT_TIMESTAMP() AS loaded_at
FROM source
WHERE TRY_CAST(CUSTOMER_ID AS NUMBER) IS NOT NULL -- Filter out invalid CUSTOMER_IDs
