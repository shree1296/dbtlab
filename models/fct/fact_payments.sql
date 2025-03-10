{{ config(
    materialized='table',
    schema='curated',
    alias='fact_payments',
    transient=False
) }}

WITH payments AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'check_number']) }} AS payment_id,
        customer_id,
        check_number,
        payment_date,
        amount AS payment_amount,
        CAST(TO_CHAR(payment_date, 'YYYYMMDD') AS NUMBER(18,0)) AS payment_date_id
    FROM {{ ref('stg_payments') }}
)

SELECT * FROM payments
ORDER BY payment_date DESC
