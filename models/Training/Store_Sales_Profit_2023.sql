

with store_final as (
select * from {{ ref('store_tbl_2023') }}
),
store_sales_final as(
select * from {{ ref('store_sales_tbl_2023') }}
),
final_sales_profit as(
select S_STORE_NAME,S_COUNTY, sum(SS_SALES_PRICE),sum(SS_NET_PROFIT) from store_final,store_sales_final
where SS_STORE_SK=SS_STORE_SK
group by 1,2
)
select * from final_sales_profit