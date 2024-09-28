with product as (

    select A.product_id,A.PRODUCT_NAME,A.state,A.Region,B.unit_sold, B.amount
    from prod.dim_product A inner join prod.Fact_Sales B
    on A.product_id=B.product_id
)
select * from product 