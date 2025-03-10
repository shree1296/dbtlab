{{ config(
    materialized='table',
    schema='curated',
    transient=False
) }}

WITH date_series AS (
    SELECT 
        DATEADD(DAY, SEQ4(), '2000-01-01') AS full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 36525))  -- Generates 100 years (2000-2099)
)

SELECT 
    full_date,
    YEAR(full_date) AS year,
    MONTH(full_date) AS month,
    DAY(full_date) AS day,
    DAYOFWEEK(full_date) AS day_of_week,
    CASE 
        WHEN DAYOFWEEK(full_date) IN (1, 7) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS day_type,
    WEEKOFYEAR(full_date) AS week_of_year,
    WEEKISO(full_date) AS iso_week_number,  
    QUARTER(full_date) AS quarter,
    YEAR(full_date) * 100 + MONTH(full_date) AS year_month,
    TO_CHAR(full_date, 'Day') AS day_name,
    TO_CHAR(full_date, 'Month') AS month_name,
    IFF(MONTH(full_date) BETWEEN 3 AND 5, 'Spring',
        IFF(MONTH(full_date) BETWEEN 6 AND 8, 'Summer',
            IFF(MONTH(full_date) BETWEEN 9 AND 11, 'Fall', 'Winter')
        )
    ) AS season,
    CAST(TO_CHAR(full_date, 'YYYYMMDD') AS NUMBER(8,0)) AS date_id
FROM date_series
WHERE full_date BETWEEN '2000-01-01' AND '2099-12-31'
