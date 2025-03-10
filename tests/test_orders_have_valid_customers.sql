SELECT fo.ORDER_NUMBER
FROM {{ ref('fact_orders') }} fo
WHERE NOT EXISTS (
    SELECT 1 
    FROM {{ ref('dim_customers') }} c 
    WHERE fo.CUSTOMER_KEY = c.CUSTOMER_KEY  -- Ensure both sides use CUSTOMER_KEY
)
AND fo.ORDER_NUMBER IS NOT NULL
ORDER BY fo.ORDER_NUMBER
