SELECT ORDER_NUMBER
FROM {{ ref('fact_orders') }}
WHERE 
    ORDER_STATUS = 'Shipped' 
    AND (
        SHIPPED_DATE IS NULL 
        OR TRY_TO_DATE(SHIPPED_DATE) IS NULL  -- Ensures valid date format
    )
