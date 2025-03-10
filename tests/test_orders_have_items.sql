SELECT fo.ORDER_NUMBER
FROM {{ ref('fact_orders') }} fo
WHERE NOT EXISTS (
    SELECT 1 
    FROM {{ ref('stg_order_details') }} od  -- Ensure this matches your staging model name
    WHERE fo.ORDER_NUMBER = od.ORDER_NUMBER
)
AND fo.ORDER_NUMBER IS NOT NULL
ORDER BY fo.ORDER_NUMBER
