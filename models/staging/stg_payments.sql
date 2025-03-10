
{{ config(
    materialized='view',
    schema='staging',
) }}




WITH source AS (
    SELECT * FROM {{ ref('src_payments') }}
),

deduplicated AS (
    SELECT
        CUSTOMER_ID AS customer_id,
        CHECK_NUMBER AS check_number,
        PAYMENT_DATE AS payment_date,
        CAST(AMOUNT AS DECIMAL(15,2)) AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY CHECK_NUMBER 
            ORDER BY PAYMENT_DATE DESC, AMOUNT DESC
        ) AS rn,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
)

SELECT
    customer_id,
    check_number,
    payment_date,
    amount,
    loaded_at
FROM deduplicated
WHERE rn = 1
