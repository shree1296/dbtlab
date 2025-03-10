{{ config(
    materialized='incremental',
    unique_key='product_line',
    schema = 'staging'
) }}

WITH source AS (
    SELECT
        PRODUCT_LINE AS product_line,
        TEXT_DESCRIPTION AS text_description,
        CURRENT_TIMESTAMP() AS loaded_date
    FROM {{ ref('src_productlines') }}
    {% if is_incremental() %}
    WHERE CURRENT_TIMESTAMP() > COALESCE((SELECT MAX(loaded_date) FROM {{ this }}), '1900-01-01')
    {% endif %}
),

deduplicated AS (
    SELECT
        product_line,
        text_description,
        loaded_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_line 
            ORDER BY loaded_date DESC, text_description DESC
        ) AS rn
    FROM source
)

SELECT
    product_line,
    text_description,
    loaded_date
FROM deduplicated
WHERE rn = 1
