{{
    config(
        materialized='table'
    )
}}

with Product_Sales as(
select City,State,sum(NA_SALES),sum(GLOBAL_SALES) from Product 
group by 1,2
)
select * from Product_Sales