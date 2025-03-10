{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH order_details AS (
    SELECT 
        ORDER_NUMBER,
        PRODUCT_CODE,
        COUNT(DISTINCT PRODUCT_CODE) AS PRODUCT_COUNT, 
        SUM(QUANTITY_ORDERED) AS TOTAL_QUANTITY,
        SUM(QUANTITY_ORDERED * PRICE_EACH) AS ORDER_TOTAL
    FROM raw_staging.stg_order_details
    GROUP BY ORDER_NUMBER, PRODUCT_CODE
),
orders AS (
    SELECT 
        ORDER_NUMBER,
        CUSTOMER_ID,
        ORDER_DATE,
        REQUIRED_DATE,
        SHIPPED_DATE,
        ORDER_STATUS,
        COMMENTS,
        LOADED_AT
    FROM raw_staging.stg_orders
),
customers AS (
    SELECT 
        CUSTOMER_ID,
        CUSTOMER_KEY
    FROM raw_curated.dim_customers
),
products AS (
    SELECT 
        PRODUCT_ID,
        PRODUCT_KEY,
        PRODUCT_NAME,
        SUPPLIER_NAME
    FROM raw_curated.dim_products
),
deduplicated_orders AS (
    SELECT 
        ORDER_NUMBER,
        CUSTOMER_ID,
        ORDER_DATE,
        REQUIRED_DATE,
        SHIPPED_DATE,
        ORDER_STATUS,
        COMMENTS,
        ROW_NUMBER() OVER (PARTITION BY ORDER_NUMBER ORDER BY LOADED_AT DESC) AS row_num
    FROM orders
    WHERE ORDER_DATE >= DATEADD(YEAR, -2, CURRENT_DATE)
)
SELECT 
    O.ORDER_NUMBER,
    C.CUSTOMER_KEY,  
    D.DATE_ID AS ORDER_DATE_ID,
    O.REQUIRED_DATE,
    O.SHIPPED_DATE,
    O.ORDER_STATUS,
    O.COMMENTS,
    OT.PRODUCT_COUNT,
    OT.TOTAL_QUANTITY,
    OT.ORDER_TOTAL,
    COALESCE(DATEDIFF(DAY, O.ORDER_DATE, O.SHIPPED_DATE), 0) AS PROCESSING_TIME,
    P.PRODUCT_KEY,
    P.PRODUCT_NAME,
    P.SUPPLIER_NAME
FROM deduplicated_orders O
JOIN order_details OT ON O.ORDER_NUMBER = OT.ORDER_NUMBER
LEFT JOIN customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
LEFT JOIN raw_curated.dim_dates D ON D.DATE_ID = TO_CHAR(O.ORDER_DATE, 'YYYYMMDD')
LEFT JOIN products P ON OT.PRODUCT_CODE = P.PRODUCT_ID
WHERE O.row_num = 1
ORDER BY O.ORDER_NUMBER
