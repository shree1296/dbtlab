with duplicate_orders as (
    select 
        ORDER_NUMBER, 
        count(*) as cnt
    from {{ ref('fact_orders') }}
    group by ORDER_NUMBER
    having count(*) > 1
)
select 
    f.*
from {{ ref('fact_orders') }} f
join duplicate_orders d
    on f.ORDER_NUMBER = d.ORDER_NUMBER
order by f.ORDER_NUMBER
