SELECT f.SUPPLIER_NAME 
FROM raw_curated.fact_orders f
LEFT JOIN raw_curated.dim_suppliers s 
    ON f.SUPPLIER_NAME = s.SUPPLIER_NAME
WHERE s.SUPPLIER_NAME IS NULL
