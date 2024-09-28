
{{
    config(
        materialized='table'
    )
}}
with product as (


select A.product_id,A.product_name,A.state, A.region, A.brand, B.quantity,
B.amount from prod.dim_product A inner join prod.fact_product_sales B
on A.product_id=B.product_id
)
select * from product